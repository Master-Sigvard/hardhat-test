// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;


contract Lottery {
    address public owner;
    address payable[] public players;
    uint [] public values;
    uint i;
    uint sum = 0;

    constructor() {
        owner = msg.sender;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }

    function getValues() public view returns (uint [] memory) {
        return values;
    }

    function enterLottery() public payable {
        require(msg.value > 0 ether);
        players.push(payable(msg.sender));
        values.push(msg.value);
        if (address(this).balance >= 10 ether) {
            chooseWinner();
        }
    }

    function randomNumber() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(owner, block.timestamp))) % sum;
    }

    function chooseWinner() private {
        for (i = 0; i < values.length; i++) {
            sum += values[i];
        }
        for (i = 1; i < values.length; i++) {
            values[i] = values[i] + values[i-1];
        }
        uint index = randomNumber();
        for (i = 0; index > values[i];) {
            i++;
        }
        players[i].transfer(address(this).balance);
        
        sum = 0;
        players = new address payable[](0);
        values = new uint[](0);
    }
}