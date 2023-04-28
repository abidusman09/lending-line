// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./LeniiToken.sol";

contract LendingLine {
    LeniiToken public leniiToken;

    mapping(address => uint256) public depositBalances;
    mapping(address => uint256) public borrowBalances;

    event Deposit(address indexed from, uint256 value);
    event Withdraw(address indexed to, uint256 value);
    event Borrow(address indexed from, uint256 value);
    event Repay(address indexed to, uint256 value);

    constructor(address _leniiTokenAddress) {
        leniiToken = LeniiToken(_leniiTokenAddress);
    }

    function deposit(uint256 _value) public {
        require(_value > 0, "Invalid deposit amount");
        leniiToken.transferFrom(msg.sender, address(this), _value);
        depositBalances[msg.sender] += _value;
        emit Deposit(msg.sender, _value);
    }

    function withdraw(uint256 _value) public {
        require(_value > 0 && depositBalances[msg.sender] >= _value, "Invalid withdrawal amount");
        leniiToken.transfer(msg.sender, _value);
        depositBalances[msg.sender] -= _value;
        emit Withdraw(msg.sender, _value);
    }

    function borrow(uint256 _value) public {
        require(_value > 0, "Invalid borrow amount");
        require(leniiToken.balanceOf(address(this)) >= _value, "Insufficient funds");
        require(leniiToken.balanceOf(msg.sender) >= borrowBalances[msg.sender] + _value, "Borrower has reached borrowing limit");

        leniiToken.transfer(msg.sender, _value);
        borrowBalances[msg.sender] += _value;
        emit Borrow(msg.sender, _value);
    }

    function repay(uint256 _value) public {
        require(_value > 0 && borrowBalances[msg.sender] >= _value, "Invalid repayment amount");
        leniiToken.transferFrom(msg.sender, address(this), _value);
        borrowBalances[msg.sender] -= _value;
        emit Repay(msg.sender, _value);
    }
}
