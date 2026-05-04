// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract OpenZeppelinNFT is ERC721("RareCoin", "RARE") , Ownable(msg.sender) {
    uint public tokenSupply=0;
    uint public constant MAX_SUPPLY = 4;
    uint public constant PRICE = 0.001 ether;

    function mint() external payable {
        require(tokenSupply < MAX_SUPPLY, "supply used up");
        require(msg.value == PRICE, "Incorrect value");
        _mint(msg.sender, tokenSupply);
        tokenSupply++;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://ipfs.io/ipfs/bafybeic5gpzszuqaeo5m4u22ut3g5hhwz7yehurhhxou2w7golakcwhyoa/";
    }

    function withdraw() external onlyOwner {
        (bool ok,)=msg.sender.call{value: address(this).balance}("");
        require(ok);
    }
}