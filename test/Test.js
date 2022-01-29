const { expect } = require("chai");
const { ethers } = require("hardhat");
describe("Token contract", function () {
  it("Deployment should assign the total supply of tokens to the owner", async function () {
    const [owner] = await ethers.getSigners();
    console.log(owner.address);
    const Token = await ethers.getContractFactory("Presale");

    const presaleContract = await Token.deploy("0x4fabb145d64652a948d72533023f6e7a623c7c53", "0x55d398326f99059fF775485246999027B3197955", "0x6d8787EA487Eb99633435E3ece87aD158c92D538", "0x5529E084C2CabA4E6BF9f053E71A905b7D6dC9e4");
    console.log(presaleContract.address);
  });
});