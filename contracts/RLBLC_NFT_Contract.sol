// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

    /**
    * @title RLBLC_NFT_Contract for granting Titan, Mogul, Whale membership to users with multiple benefits
    * ERC721Tradable - ERC721 contract that whitelists a trading address and allow them to mint and resell NFTs
    */
    contract RLBLC_NFT_Contract is ERC721, ERC721URIStorage, Ownable {
    using SafeMath for uint256;

    /// @notice Limited numbers of NFT with Titan-Black 1-31, Mogul-Platinum 32-355(324) and Whale-Gold 356-1002(647)
    uint public platinumCounter = 32; 
    uint public goldCounter = 356;   
    uint public blackCounter = 1;    
    
    /// @notice Prices of all three types 
    uint public platinumPrice = 3*10**18;
    uint public goldPrice = 3*10**18;
    uint public blackPrice = 3*10**18;

    /// @notice whitelist period timestamp after which anyone can mint without whitelisting
    uint public whitelistPeriod;

    /// @notice Base url for NFT storage directory    
    string public baseURI = "https://bafybeibj6wp62eo5vcebst2v2n4mpxhvmqgpewdsnmd3tlpffppwbw4jsu.ipfs.nftstorage.link/";

    /// @notice Mapping to store whitelist members
    mapping(address => bool) public whitelistedAddresses;
    address[] public whitelistAddressesList;

    /// @notice Mapping to store prices of NFTs for secondary sale, 
    /// @dev nftResellPrices = 0, means NFT not listed for resale
    mapping(uint => uint) public nftResellPrices;

    event Mint(string nft, uint count, address to);
    event ChangePrice( uint platinum, uint gold, uint black);
    event Resell( uint tokenId, uint price);
    event Purchase(address from, address to, uint tokenId, uint price);
    event Withdrawal(uint balance);
    event ChangeURI(string newUri);
    event Received(address sender, uint balance);
    event Fallback(address sender, uint balance);

    /// @notice Function Contract Constructor defining Name and Symbol of NFT contract
    /// @param _name Name of NFT club
    /// @param _symbol Symbol of NFT club
    /// @param _whitelistPeriod White list period in days
    constructor(
        string memory _name, 
        string memory _symbol, 
        uint _whitelistPeriod
    ) ERC721( _name, _symbol) {
        whitelistPeriod = block.timestamp.add(_whitelistPeriod.mul(86400));
    } 

    ///@notice Modifier to allow only whitelisted users to purchase NFTs
    modifier isWhitelisted() {
        if(block.timestamp < whitelistPeriod){
        require(whitelistedAddresses[msg.sender], "You need to be whitelisted");
        }
        _;
    }

    /// @notice Function to allow users to whitelist themselves
    function whiteListUser() external {
        whitelistedAddresses[msg.sender] = true;
        whitelistAddressesList.push(msg.sender);
    }

    /// @notice Function to allow export of Whitelisted users
    function getWhiteListUsers()external view returns( address  [] memory){
    return whitelistAddressesList;
    }

    /// @notice Function to replace baseURI
    /// @param _baseUri new baseURI
    function changeBaseURI(string calldata _baseUri) external onlyOwner {
        baseURI = _baseUri;
        emit ChangeURI(_baseUri);
    }

    /// @notice Function to change whitelist period	
    /// @param _days Numbers of days to add to whitelist period from block timestamp	
    function changeWhitelistPeriod(uint _days) external onlyOwner {	
        whitelistPeriod = block.timestamp.add(_days.mul(86400));	
    }

    /// @notice Function to change prices of NFTs	
    /// @param _platinumPrice  Prices of platinum NFT category in wei	
    /// @param _goldPrice  Prices of gold NFT category in wei	
    /// @param _blackPrice  Prices of black NFT category in wei     	
    function changeNFTPrice( 	
        uint _platinumPrice, 	
        uint _goldPrice, 	
        uint _blackPrice	
    ) external onlyOwner {	
        if(_platinumPrice > 0){ platinumPrice = _platinumPrice; }	
        if(_goldPrice > 0){ goldPrice = _goldPrice; }	
        if(_blackPrice > 0){ blackPrice = _blackPrice; }	
        emit ChangePrice( _platinumPrice, _goldPrice, _blackPrice);	
    }

    /// @notice Function to mint Platinum NFT
    /// @dev Checks to limit numbers of platinum NFTs and NFT price
    function platinumMint() external payable isWhitelisted {
        require(platinumCounter < 356,'All Platinum NFT minted');
        require(msg.value >= platinumPrice, "Insufficient funds for Platinum minting");  
        _safeMint(msg.sender, platinumCounter);
        // _setTokenURI(platinumCounter, string(abi.encodePacked(Strings.toString(platinumCounter), ".json")));
        _setTokenURI(platinumCounter, string.concat(Strings.toString(platinumCounter),'.json'));
        emit Mint("Platinum", platinumCounter, msg.sender);
        platinumCounter++;
    }

    /// @notice Function to mint Gold NFT
    /// @dev Checks to limit numbers of NFT and NFT value
    function goldMint() external payable isWhitelisted {
        require(goldCounter < 1003,'All Gold NFT minted');
        require(msg.value >= goldPrice, "Insufficient funds for Gold minting");  
        _safeMint(msg.sender, goldCounter);
        // _setTokenURI(goldCounter, string(abi.encodePacked(Strings.toString(goldCounter), ".json")));
        _setTokenURI(goldCounter, string.concat(Strings.toString(goldCounter),'.json'));
        emit Mint("Gold", goldCounter, msg.sender);
        goldCounter++;
    }

    /// @notice Function to mint Black NFT
    /// @dev Checks to limit numbers of NFT and NFT value
    function blackMint() external payable isWhitelisted {
        require(blackCounter < 32,'All Gold NFT minted');
        require(msg.value >= blackPrice, "Insufficient funds for Black minting");  
        _safeMint(msg.sender, blackCounter);
        // _setTokenURI(blackCounter, string(abi.encodePacked(Strings.toString(blackCounter), ".json")));
        _setTokenURI(blackCounter, string.concat(Strings.toString(blackCounter),'.json'));
        emit Mint("Black", blackCounter, msg.sender);
        blackCounter++;
    }

    /// @notice Function to list NFT for secondary sale by its owner
    /// @dev Checks for price and ownership
    /// @param _tokenId  ID of NFT held by owner which he want to resell
    /// @param _price Price in Wei at which NFT owner want to resell
    function resellNFT(
        uint _tokenId, 
        uint _price
    ) external {
        require(msg.sender == ownerOf(_tokenId), 'Only NFT Owners can resell their NFT');
        require(_price > 0, 'Price must be greater than 0');
        nftResellPrices[_tokenId] = _price;
        emit Resell( _tokenId, _price);
    }

    /// @notice Function to purchase NFT
    /// @dev Checks for price and ownership, overflow revert inbuild in solidity >0.8
    /// @dev Royalty 7.5% on sales 
    /// @param _from address of seller listed the NFT
    /// @param _tokenId token ID of NFT to be transferred
    function purchaseNFT(
        address _from,
        uint256 _tokenId
    ) external payable {
        require(nftResellPrices[_tokenId] > 0, "NFT not for sale");
        require(msg.value >= nftResellPrices[_tokenId], "Insufficient Payment");
        require(_from == ownerOf(_tokenId), "From address is not NFT owner");
        _transfer(_from, msg.sender, _tokenId);   
        uint sellerPrice = nftResellPrices[_tokenId].mul(37).div(40);
        payable(_from).transfer(sellerPrice);
        emit Purchase(_from, msg.sender, _tokenId, nftResellPrices[_tokenId]);
        nftResellPrices[_tokenId] = 0;
    }

    /// @dev Function to restrict transfer without payment
    function transferFrom(
        address,
        address,
        uint256
    ) public pure override {
        require(false, "Transfer allowed only through payment flow");
    }

    /// @notice Function to withdraw contract balance in owner's address
    function withdraw() external onlyOwner{
        uint balance = address(this).balance;
        payable(address(0xC051D2013d8eAb456CFB3a9a08d115935a86Ea3A)).transfer(balance);
    }

    /// The following functions are overrides required by Solidity.

    /// @dev Function to restrict transfer by 3rd parties  
    function _safeTransfer(
        address,
        address,
        uint256,
        bytes memory
    ) internal pure override {
        require(false, "Safe Transfers Not Allowed");
    }

    /// @dev Function to restrict burning of NFTs 
    function _burn(uint256) pure internal override(ERC721, ERC721URIStorage) {
        require(false, "NFT BURN NOT ALLOWED");
    }

    /// @dev Function Override 
    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    /// @dev Function Override 
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
    /// @dev Function to override renounce ownership feature
    function renounceOwnership() public override pure{	
        require(false, "Not Allowed");	
    }
}
