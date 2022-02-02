// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

import '../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol';



contract SocialCreditsToken is ERC20{
    address public admin;
    event Bought(uint256 amount);
    event Claimed(uint256 amount);
    modifier OnlyOwner(){
        require(msg.sender == admin, "only admin");
        _;
    }
    constructor() ERC20("SocialCreditsToken", "SCT"){
        _mint(msg.sender, 1 ether);
        admin = msg.sender;
    }

    function burn(uint amount) external {
        _burn(msg.sender, amount);
    }


}

contract GdeSS is SocialCreditsToken{
    mapping (address => uint) BensToBalance;
    mapping (address => bool) BensToLock;
    uint contractBalance = 0;
    modifier notLocked(){
        require(!BensToLock[msg.sender],"user cannot be locked");
        _;
    }

    function addBeneficiary(address _beneficiary, uint _tokenAmount) public OnlyOwner{
        contractBalance -= _tokenAmount;
        BensToBalance[_beneficiary] += _tokenAmount;
    }

    function addBeneficiaries (address[] calldata _beneficiaries, uint _tokenAmount) public OnlyOwner{
        for( uint i=0; i<_beneficiaries.length; i++){
            contractBalance -= _tokenAmount;
            BensToBalance[_beneficiaries[i]] += _tokenAmount;
        }
    }

    function deposit() public OnlyOwner{
        contractBalance += BensToBalance[msg.sender];
        BensToBalance[msg.sender] = 0;
    }

    function decReward(address _beneficiary, uint _token_amount) public OnlyOwner{
        require(_token_amount > 0, "Amount is undefined");
        require(_token_amount <= BensToBalance[_beneficiary], "Not enough tokens on the balance");
        BensToBalance[_beneficiary] -= _token_amount;
    }

    function incReward(address _beneficiary, uint _token_amount) public OnlyOwner{
        require(_token_amount > 0, "Amount is undefined");
        BensToBalance[_beneficiary] += _token_amount;
    }

    function SetLock(address _beneficiary, bool islocked) OnlyOwner public{
        require(BensToLock[_beneficiary] != islocked, "User is already blocked");
        BensToLock[_beneficiary] = islocked;
    }

    function EmergencyWithdraw() public OnlyOwner{
        BensToBalance[msg.sender] += contractBalance;
        contractBalance = 0;
    }

    function Claim() payable public notLocked{
        contractBalance += BensToBalance[msg.sender];
        BensToBalance[msg.sender] = 0;
    }

}