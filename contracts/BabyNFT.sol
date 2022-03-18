  pragma solidity >=0.6.0 <0.7.0;
  //SPDX-License-Identifier: MIT

  //import "hardhat/console.sol";
  import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
  import "@openzeppelin/contracts/utils/Counters.sol";
  import "@openzeppelin/contracts/access/Ownable.sol";
  //learn more: https://docs.openzeppelin.com/contracts/3.x/erc721

  // GET LISTED ON OPENSEA: https://testnets.opensea.io/get-listed/step-two

  contract BabyNFT is ERC721 {
  uint256 public counter;
  constructor() public ERC721("BabyNFT", "BabyNFT") {
    _setBaseURI("https://ipfs.io/ipfs/");
    counter = 0;
  }

  function mintItem(string memory tokenURI)
      public
      returns (uint256)
  {
      _mint(msg.sender, counter);
      _setTokenURI(counter, tokenURI);
      counter++;
      return counter;
  }
}