const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
  
    console.log("Deploying contracts with the account:", deployer.address);
  
    console.log("Account balance:", (await deployer.getBalance()).toString());
  
    // const Token = await ethers.getContractFactory("BABYV2Token");
    // const token = await Token.deploy();
    const ICOcontract = await ethers.getContractFactory("Presale");
    // const token = await ICOcontract.deploy("0xeD24FC36d5Ee211Ea25A80239Fb8C4Cfd80f12Ee", "0x377533D0E68A22CF180205e9c9ed980f74bc5050", "0x6d8787EA487Eb99633435E3ece87aD158c92D538", "0x5529E084C2CabA4E6BF9f053E71A905b7D6dC9e4");
    const token = await ICOcontract.deploy("0xed24fc36d5ee211ea25a80239fb8c4cfd80f12ee", "0x6d8787EA487Eb99633435E3ece87aD158c92D538", "0x49F86C1Da7532280157227B2bd9F64fE6E250ef9");
    console.log("Token address:", token.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
});