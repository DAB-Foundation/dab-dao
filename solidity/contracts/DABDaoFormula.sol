pragma solidity ^0.4.11;

import './Math.sol';

contract DABDaoFormula is Math{
    function DABDaoFormula(){}

    function isApproved(uint256 _circulation, uint256 _vote, uint256 _supportRate) public returns (bool){
        _circulation = EtherToFloat(_circulation);
        _vote = EtherToFloat(_vote);
        _supportRate = div(Float(_supportRate), Float(100));
        uint256 realRate = div(_vote, _circulation);
        if(realRate >= _supportRate){
            return true;
        } else {
            return false;
        }
    }
}
