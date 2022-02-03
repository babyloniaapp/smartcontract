const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
  
    console.log("Deploying contracts with the account:", deployer.address);
  
    console.log("Account balance:", (await deployer.getBalance()).toString());
  
    // const Token = await ethers.getContractFactory("Presale");
    // const token = await Token.deploy();
    const ICOcontract = await ethers.getContractFactory("Presale");
    // const token = await ICOcontract.deploy("0xeD24FC36d5Ee211Ea25A80239Fb8C4Cfd80f12Ee", "0x377533D0E68A22CF180205e9c9ed980f74bc5050", "0x6d8787EA487Eb99633435E3ece87aD158c92D538", "0x5529E084C2CabA4E6BF9f053E71A905b7D6dC9e4");
    const token = await ICOcontract.deploy("0xC0feCf63bB4c750822c9B2938304642D3B61843f", "0xed9ba81d068A8df68E3c44D1c7C276AF244356E9", "0x49f86c1da7532280157227b2bd9f64fe6e250ef9");
    console.log("Contract address:", token.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
});