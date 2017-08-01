pragma solidity ^0.4.0;

import 'Math.sol';

contract DAOFormula is Math{
    function DAOFormula(){}

    function isApproved(uint256 _circulation, uint256 _vote, uint256 _supportRate) public returns (bool){
        _circulation = EtherToFloat(_circulation);
        _vote = EtherToFloat(_vote);
        _supportRate = Float(_supportRate);
        uint256 realRate = div(_vote, _circulation);
        if(realRate >= _supportRate){
            return true;
        } else {
            return false;
        }
    }
}
