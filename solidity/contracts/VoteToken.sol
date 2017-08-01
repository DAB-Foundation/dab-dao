pragma solidity ^0.4.11;

import './SmartToken.sol';

contract VoteToken is SmartToken{
    function VoteToken(string _name, string _symbol, uint8 _decimals)
    SmartToken(_name, _symbol, _decimals){}
}
