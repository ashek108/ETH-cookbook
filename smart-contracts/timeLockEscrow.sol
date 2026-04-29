// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract TimelockEscrow {
    address public seller;

    /**
     * The goal of this exercise is to create a Time lock escrow.
     * A buyer deposits ether into a contract, and the seller cannot withdraw it until 3 days passes. Before that, the buyer can take it back
     * Assume the owner is the seller
     */

    constructor() {
        seller = msg.sender;
    }

    mapping(address => uint) public balances;
    mapping(address => uint) public time;
    
    /**
     * creates a buy order between msg.sender and seller
     * escrows msg.value for 3 days which buyer can withdraw at anytime before 3 days but afterwhich only seller can withdraw
     * should revert if an active escrow still exist or last escrow hasn't been withdrawn
     */
    function createBuyOrder() external payable {
        // your code here
        require(msg.value > 0, "No ETH");
        require(balances[msg.sender]==0, "Active Escrow exists");
        balances[msg.sender]=msg.value;
        time[msg.sender]=block.timestamp;
    }

    /**
     * allows seller to withdraw after 3 days of the escrow with @param buyer has passed
     */
    function sellerWithdraw(address buyer) external {
        // your code here
        require(msg.sender==seller, "Not the seller");
        require(block.timestamp>=time[buyer] + 3 days, "wait for 3 days");
        require(balances[buyer]>0, "Escrow doesn't exist");

        uint amount = balances[buyer];
        balances[buyer]=0;
        time[buyer]=0;

        (bool ok,)= seller.call{value: amount}("");
        require(ok, "Transfer failed");
    }

    /**
     * allows buyer to withdraw at anytime before the end of the escrow (3 days)
     */
    function buyerWithdraw() external {
        // your code here
        require(block.timestamp<time[msg.sender]+3 days, "3 days have passed");
        require(balances[msg.sender]>0, "Escrow doesn't exist");

        uint amount = balances[msg.sender];
        balances[msg.sender]=0;
        time[msg.sender]=0;

        (bool ok,)= msg.sender.call{value: amount}("");
        require(ok, "Transfer failed");
    }

    // returns the escrowed amount of @param buyer
    function buyerDeposit(address buyer) external view returns (uint256) {
        // your code here
        return balances[buyer];
    }
}
