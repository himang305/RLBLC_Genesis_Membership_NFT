// image file script

    fs = require('fs')
    fs.readFile('1.png', function (err, data) {
        if (err) throw err;

        for(var i=2; i<101; i++){ 
        fs.writeFile(i+'.png', data, function (err) {
            if (err) throw err;
            console.log(i);
        });
        }
    
    });


// metadata file script
const fs = require('fs');
 
for(var i=1; i<32; i++){ 
    var k = i;
    var s = i ;
    var j = k.toString().padStart(7,"0");

    var membership = s + ' of 31 Titan Membership NFTs';
    var desc = "Member Benefits (what you get)\: Early Access to RLBLC investment opportunities. (Priority before Mogul and Whale) Member pricing on all stays at RLBLC properties. (Discount off market rates.) Advanced booking at RLBLC properties. Priority Whitelist for all upcoming RLBLC project collaborations. Access to our private alpha group. Early beta access to the RLBLC Web3 real estate lifestyle dapp. Automatic Whitelist inclusion to RLBLC\’s first artist NFT collaboration coming Summer 2022. Automatic Whitelist inclusion to RLBLC\’s future artist collaborations. VIP List for all RLBLC parties, dinners, and events. (RSVP Required.)";

var jsonData = {
    "name" : "Titan Genesis Membership NFT",
    "description" : desc,
    "animation_url" : "https://bafybeib6orvvhkgzuvylvugsu2lopzm2vm6eftqyoaekrddrs6uzhnrwha.ipfs.nftstorage.link/" + j + ".mp4",
    "membership": membership
};

var jsonContent = JSON.stringify(jsonData,null,10);
// console.log(jsonContent);
 
fs.writeFile( i+".json", jsonContent, 'utf8', function (err) {
    if (err) {
        console.log("An error occured while writing JSON Object to File.");
        return console.log(err);
    }
    console.log("JSON file has been saved.");
});
}

for(var i=32; i<356; i++){ 
    var k = i;
    var s = i - 31;
    var j = k.toString().padStart(7,"0");

    var membership = s + ' of 324 Mogul Membership NFTs';
    var desc = "Member Benefits (what you get)\: Early Access to RLBLC investment opportunities. (Priority before Whale) Member pricing on all stays at RLBLC properties. (Discount off market rates.) Advanced booking at RLBLC properties. Priority Whitelist for all upcoming RLBLC project collaborations. Access to our private alpha group. Early beta access to the RLBLC Web3 real estate lifestyle dapp. Automatic Whitelist inclusion to RLBLC\’s first artist NFT collaboration coming Summer 2022. Automatic Whitelist inclusion to RLBLC\’s future artist collaborations. VIP List for all RLBLC parties, dinners, and events. (RSVP Required.)";

var jsonData = {
    "name" : "Mogul Genesis Membership NFT",
    "description" : desc,
    "animation_url" : "https://bafybeib6orvvhkgzuvylvugsu2lopzm2vm6eftqyoaekrddrs6uzhnrwha.ipfs.nftstorage.link/" + j + ".mp4",
    "membership": membership
};

var jsonContent = JSON.stringify(jsonData,null,10);
// console.log(jsonContent);
 
fs.writeFile( i+".json", jsonContent, 'utf8', function (err) {
    if (err) {
        console.log("An error occured while writing JSON Object to File.");
        return console.log(err);
    }
    console.log("JSON file has been saved.");
});
}

for(var i=356; i<1003; i++){ 
    var k = i;
    var s = i - 355;
    var j = k.toString().padStart(7,"0");

    var membership = s + ' of 647 Whale Membership NFTs';
    var desc = "Member Benefits (what you get)\: Early Access to RLBLC investment opportunities. (Priority after Mogul and Titan) Member pricing on all stays at RLBLC properties. (Discount off market rates.) Advanced booking at RLBLC properties. Priority Whitelist for all upcoming RLBLC project collaborations. Access to our private alpha group. Early beta access to the RLBLC Web3 real estate lifestyle dapp. Automatic Whitelist inclusion to RLBLC\’s first artist NFT collaboration coming Summer 2022. Automatic Whitelist inclusion to RLBLC\’s future artist collaborations. VIP List for all RLBLC parties, dinners, and events. (RSVP Required.)";

var jsonData = {
    "name" : "Whale Genesis Membership NFT",
    "description" : desc,
    "animation_url" : "https://bafybeib6orvvhkgzuvylvugsu2lopzm2vm6eftqyoaekrddrs6uzhnrwha.ipfs.nftstorage.link/" + j + ".mp4",
    "membership": membership
};

var jsonContent = JSON.stringify(jsonData,null,10);
// console.log(jsonContent);
 
fs.writeFile( i+".json", jsonContent, 'utf8', function (err) {
    if (err) {
        console.log("An error occured while writing JSON Object to File.");
        return console.log(err);
    }
    console.log("JSON file has been saved.");
});
}




// read json files and add key values at last

const fs = require('fs');
for(var i=1; i<51; i++){ 

let content = JSON.parse(fs.readFileSync(i+'.json', 'utf8'));
// edit or add property
content.name = "OG NFT";
content.image = "ipfs/QmadotpQy7Jjb9CG55ZUWwdxMXkECtz7Fx9NdWyMbKZPCy/"+ i +".jpeg",
//write file
contents = JSON.stringify(content,null,10);

fs.writeFileSync(i+'.json', contents);

}
