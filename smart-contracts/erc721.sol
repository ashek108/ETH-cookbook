// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

contract SimpleNFT {
    using Strings for uint;
    mapping(address => mapping(address => bool)) private _operators;
    mapping(uint => address) private _owners;
    mapping(address => uint) private _balances;

    string baseURL = "https://example.com/images/";

    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);


    function mint(uint _tokenId) external {
        require(_owners[_tokenId] == address(0), "already minted");
        require(_tokenId < 100, "tokenId too large");

        emit Transfer(address(0), msg.sender, _tokenId);
        _owners[_tokenId] = msg.sender;
        _balances[msg.sender] +=1;
    }

    function ownerOf(uint _tokenId) external view returns (address) {
        require(_owners[_tokenId] != address(0), "no such token");
        return _owners[_tokenId];
    }

    function transferFrom(address _from, address _to, uint _tokenId) external {
        require(_owners[_tokenId] == _from, "ur not the owner of token");
        require(_owners[_tokenId] != address(0), "no such token");
        require(msg.sender == _from || _operators[_from][msg.sender], "required to be the owner");

        emit Transfer(_from, _to, _tokenId);
        _operators[_from][msg.sender] = false;
        _owners[_tokenId] = _to;

        _balances[_from] -=1;
        _balances[_to] +=1;
    }

    function balanceOf(address _owner) external view returns (uint256) {
        require(_owner != address(0), "zero address");
        return _balances[_owner];
    }


    function tokenURI(uint _tokenId) external view returns (string memory) {
        require(_owners[_tokenId] != address(0), "no such token");
        return string(abi.encodePacked(baseURL, _tokenId.toString()));
    }

    function setApprovalForAll(address _operator, bool _approved) external {
        emit ApprovalForAll(msg.sender, _operator, _approved);
        _operators[msg.sender][_operator] = _approved;
    }

    function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
        return _operators[_owner][_operator];
    }
}