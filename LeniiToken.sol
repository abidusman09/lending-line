// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LeniiToken {
    string public name = "LeniiToken";
    string public symbol = "LENII";
    uint8 public decimals = 18;
    uint256 public totalSupply = 10000 * (10 ** uint256(decimals));

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Insufficient allowance");
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
    
    function faucet(address _recipient, uint256 _amount) external payable {
        require(_amount <= 100, "Amount must be less than or equal to 100");
        require(msg.value >= _amount * 1 ether, "Insufficient etheeer sent");
        balanceOf[_recipient] += _amount;
        emit Transfer(address(this), _recipient, _amount);
    }
}
