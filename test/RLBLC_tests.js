const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("RLBLC NFT Contract Test Cases", function () {
  it("RLBLC Deploy, Whitelist and MINT", async function () {

    const [owner, addr1, addr2, treasury] = await ethers.getSigners();

    console.log(treasury.address);
    const Contract = await ethers.getContractFactory("RLBLC_NFT_Contract");
    const contract = await Contract.deploy("RLBLC_NFTs", "RLBLC", 2);
    await contract.deployed();
    console.log("Contract Deployed");

    // check for minting without whitelisting   
    await expect(contract.connect(addr1).blackMint({value: hre.ethers.utils.parseEther("3")})).to.be.revertedWith("You need to be whitelisted");

    // check for whitelisting   
    const whiteListTx = await contract.connect(addr1).whiteListUser();
    await whiteListTx.wait();
    console.log("Whitelisted checked");


    // check for minting
    const mintTx = await contract.connect(addr1).blackMint({value: hre.ethers.utils.parseEther("3")});
    await mintTx.wait();
    console.log("Minting Success");


    // check for minting access after whitelist period
    const blockNumBefore = await ethers.provider.getBlockNumber();
    const blockBefore = await ethers.provider.getBlock(blockNumBefore);
    const timestampBefore = blockBefore.timestamp;
    await network.provider.send("evm_setNextBlockTimestamp", [timestampBefore + 87400*2])
    const mint2Tx = await contract.connect(addr2).platinumMint({value: hre.ethers.utils.parseEther("3")});
    await mint2Tx.wait();


    expect(await contract.tokenURI(32)).to.equal("https://bafybeibj6wp62eo5vcebst2v2n4mpxhvmqgpewdsnmd3tlpffppwbw4jsu.ipfs.nftstorage.link/32.json");

    // check for token URI ID 1  
    expect(await contract.tokenURI(1)).to.equal("https://bafybeibj6wp62eo5vcebst2v2n4mpxhvmqgpewdsnmd3tlpffppwbw4jsu.ipfs.nftstorage.link/1.json");

    // check for purchase of NFT not on sale
    await expect(contract.connect(addr2).purchaseNFT(addr1.address, 1)).to.be.revertedWith("NFT not for sale");

    // check for NFT secondary sale
    await contract.connect(addr1).resellNFT(1, 4);
    console.log("NFT Resale check success");

    // check for price of NFT
    console.log("NFT Price Check : ", await contract.blackPrice());

    // check for NFT purchase  
    await contract.connect(addr2).purchaseNFT(addr1.address, 1, {value: hre.ethers.utils.parseEther("4")});
    console.log("NFT purchase success");

    // check for NFT ownerchip transfer after purchase
    expect(await contract.ownerOf(1)).to.equal(addr2.address);
    console.log("NFT Ownership transfer success");

    // contract balance = 1 mint 3eth + 1 royalty 7.5% of 4 = 3.3 eth
    // expect(await contract.provider.getBalance(contract.address)).to.equal(3300000000000000000);
    console.log(await contract.provider.getBalance(contract.address));


    // withdraw balance in treasury
    await contract.connect(owner).withdraw();

    // change treasury address before this test
    // check royalty and mint price withdrawn to treasury 
    // expect(await contract.provider.getBalance(treasury.address)).to.equal(10003300000000000000000);
    console.log("Treasury Balance: ", await contract.provider.getBalance(treasury.address));

    // get whitelist users after whitelisting
    const whiteList2Tx = await contract.connect(addr2).whiteListUser();
    await whiteList2Tx.wait();

    console.log("Export Whitelisted Users Array : " , await contract.getWhiteListUsers());

  
  });
});
