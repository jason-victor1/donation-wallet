// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

contract MyContract {
    address public owner;
    address public beneficiary;

    constructor(address _beneficiary) {
        owner = msg.sender;
        beneficiary = _beneficiary;
    }

    function updateBeneficiary(address _beneficiary) external {
        require(msg.sender == owner, "Only owner can update the beneficiary");
        beneficiary = _beneficiary;
    }

    function deposit () external payable {
        uint donationAmount = msg.value * 1 / 100;
        (bool sent, ) = payable(beneficiary).call{value: donationAmount}("");
        require(sent == true, "transfer failed");
    }
    
    // 1 ether = 10 ^ 18 Wei
    // 9900000000000000000
    function withdraw(address recepient, uint amount) external {
        require(msg.sender == owner, "Only owner can withdraw funds");
        require(address(this).balance >= amount, "Amount too big");
        (bool sent, ) = payable(recepient).call{value: amount}("");
        require(sent == true, "transfer failed");
    }

    receive () external payable{
        uint donationAmount = msg.value * 1 / 100;
        (bool sent, ) = payable (beneficiary).call{value: donationAmount}("");
        require(sent == true, "transfer failed");
    }
}