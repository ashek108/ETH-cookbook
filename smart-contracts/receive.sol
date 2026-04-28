// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TakeMoney {
    receive() external payable { }
    function viewBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract ForwardMoney {
    function viewBalance() public view returns (uint) {
        return address(this).balance;
    }

    function payMe() public payable {}
    function sendMoney(address luckyContract) public payable {
        uint myBalance = viewBalance();
        (bool ok,)=luckyContract.call{value: myBalance}("");
        require(ok, "tmkc fail ho gaya");
    }
}

// sthg very interesting: use payMe() in ForwardMoney to deposit 5 ether.
// Now, call sendMoney() and type 50 ether. Guess how much money gets transferred? => 55
// So the money reaches ForwardMoney contract and then goes to TakeMoney, 
// which is NOT shown in the txn data, that shows 
// FROM: my wallet    
// TO: TakeMoney()  
// since most explorers simplify the recipients and compress internal txns