const { expect } = require("chai");
const { ethers } = require("hardhat");
describe("Token contract", function () {
  it("Deployment should assign the total supply of tokens to the owner", async function () {
    const [owner] = await ethers.getSigners();
    console.log(owner.address);
    const Token = await ethers.getContractFactory("Presale");

    const presaleContract = await Token.deploy("0xed24fc36d5ee211ea25a80239fb8c4cfd80f12ee", "0x6d8787EA487Eb99633435E3ece87aD158c92D538", "0x49f86c1da7532280157227b2bd9f64fe6e250ef9");
    // await presaleContract.connect(owner).DepositBusd(10);
    console.log(presaleContract.address);
  });
});