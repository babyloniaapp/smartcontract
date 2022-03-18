const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
  
    console.log("Deploying contracts with the account:", deployer.address);
  
    console.log("Account balance:", (await deployer.getBalance()).toString());
  
    // const Token = await ethers.getContractFactory("BABYV2Token");
    // const token = await Token.deploy();
    const ICOcontract = await ethers.getContractFactory("Presale");
    const token = await ICOcontract.deploy("0xed24fc36d5ee211ea25a80239fb8c4cfd80f12ee", "0xeA3B1C3CE9a168f5AF6F9B8E1B4E65B7f727eCa0", "0x49f86c1da7532280157227b2bd9f64fe6e250ef9");
    console.log("Contract address:", token.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
});