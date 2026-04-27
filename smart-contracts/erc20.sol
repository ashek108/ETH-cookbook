// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ERC20 {
    string public name;
    string public symbol;

    mapping(address => uint256) public balanceOf;
    address public owner;
    uint public decimals;
    uint256 public totalSupply;

    // owner -> spender (allowance)
    // this enables the owner to give allowance to multiple addresses
    mapping(address => mapping(address => uint256)) public allowance;

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
        decimals = 18;

        owner = msg.sender;
    }

    function mint(address to, uint256 amount) public {
        require(msg.sender==owner, "only owner can mint tokens");
        totalSupply += amount;
        balanceOf[to] += amount;
    }

    function helpTransfer(address from, address to, uint256 amount) internal returns (bool) {
        require(balanceOf[from] >= amount, "not enough money");
        require(to != address(0), "cannot send to zero address");
        balanceOf[from] -= amount;
        balanceOf[to] += amount;

        return true;
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        return helpTransfer(msg.sender, to, amount);
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        allowance[msg.sender][spender] = amount;

        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        if (msg.sender != from) {
            require(allowance[from][msg.sender] >= amount, "not enough allowance");
            allowance[from][msg.sender] -= amount;
        }

        return helpTransfer(from, to, amount);
    }

}
