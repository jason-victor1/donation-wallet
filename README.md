# Donation Wallet Smart Contract

This is a simple Ethereum smart contract that allows for donations and withdrawals. This includes a portion of each deposit automatically sent to a designated beneficiary.

## Overview

The `DonationWallet` contract was designed to manage ether deposits and automate a small percentage donation to a beneficiary. I, as the contract owner, could update the beneficiary and withdraw funds from the contract.

## Contract Details

### State Variables

- `address public owner;`: The address of the contract owner, set during deployment.
- `address public beneficiary;`: The address of the beneficiary, set during deployment and could be updated by the owner.

### Constructor

```solidity
constructor(address _beneficiary) {
    owner = msg.sender;
    beneficiary = _beneficiary;
}
```
- Set the `owner` to the address deploying the contract.
- Set the `beneficiary` to the address provided as `_beneficiary`.

### Functions

#### `updateBeneficiary`

```solidity
function updateBeneficiary(address _beneficiary) external {
    require(msg.sender == owner, "Only owner can update the beneficiary");
    beneficiary = _beneficiary;
}
```
- Allowed the owner to update the beneficiary address.

#### `deposit`

```solidity
function deposit () external payable {
    uint donationAmount = msg.value * 1 / 100;
    (bool sent, ) = payable(beneficiary).call{value: donationAmount}("");
    require(sent == true, "transfer failed");
}
```
- Allowed anyone to deposit ether into the contract.
- Automatically donated 1% of the deposited amount to the beneficiary.

#### `withdraw`

```solidity
function withdraw(address recepient, uint amount) external {
    require(msg.sender == owner, "Only owner can withdraw funds");
    require(address(this).balance >= amount, "Amount too big");
    (bool sent, ) = payable(recepient).call{value: amount}("");
    require(sent == true, "transfer failed");
}
```
- Allowed the owner to withdraw a specified amount to a given recipient address.

#### `receive`

```solidity
receive () external payable {
    uint donationAmount = msg.value * 1 / 100;
    (bool sent, ) = payable(beneficiary).call{value: donationAmount}("");
    require(sent == true, "transfer failed");
}
```
- A fallback function that got called when the contract received ether without any data.
- Donated 1% of the received ether to the beneficiary.

## Deployment and Usage

### Deployment Parameters

When deploying the contract, I ensured to pass the correct beneficiary address as a parameter to the constructor.

### Example Usage

1. **Deploy the Contract**
   - Deployed with the beneficiary address: `0xAb8...35cb2`. Please see below for the result of the contract deployment.

![Deployed Contract Screenshot](https://github.com/jason-victor1/donation-wallet/blob/main/donation%20deployed%20contract.png?raw=true)

2. **Deposit Ether**
   - When 10 ether was deposited, 1% (0.1 ether) was automatically sent to the beneficiary. Please see below screenshots for the deposit of 10 ether.

![Deployed Contract Screenshot](https://github.com/jason-victor1/donation-wallet/blob/main/deposit%2010%20ether.png?raw=true)

![Deployed Contract Screenshot](https://github.com/jason-victor1/donation-wallet/blob/main/beneficiary%20account%20result.png?raw=true)

   - The contract retained the remaining 9.9 ether.

3. **Withdraw Ether**
   - I, as the owner, withdrew 9.9 ether back to my address. The withdraw function had two parameters which were the recepient amount (owner address only) and Wei amount (1 ether     = 10 ^ 18 Wei so 9900000000000000000 Wei). Please see below screenshots for the performance of the withdrawal.

![Deployed Contract Screenshot](https://github.com/jason-victor1/donation-wallet/blob/main/withdraw%20with%20owner%20and%20wei%20.png?raw=true)

![Deployed Contract Screenshot](https://github.com/jason-victor1/donation-wallet/blob/main/withdrawal%20performed.png?raw=true)


### Current Account Balance

#### Beneficiary Address:`0xAb8...35cb2`

#### Owner Address: `0x5B3...eddC4`

- **Initial Balance**: 89.9999999999998657882 ether
- **New Balance After Withdrawal**: 99.8999999999998657882 ether

Please see below screenshot reflecting the new balance after withdrawal.

![Deployed Contract Screenshot](https://github.com/jason-victor1/donation-wallet/blob/main/owner%20account%20updated.png?raw=true)

### Summary of Operations

- **Total Deposit**: 10 ether
- **Donation to Beneficiary**: 0.1 ether
- **Remaining in Contract**: 9.9 ether
- **Owner's New Balance After Withdrawal**: 99.8999999999998657882 ether

