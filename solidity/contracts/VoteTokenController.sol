pragma solidity ^0.4.11;

import './interfaces/ISmartToken.sol';
import './SmartTokenController.sol';

/*
    Vote Token Controller

*/
contract VoteTokenController is SmartTokenController{

/**
    @dev constructor

    @param _token   vote token
*/
    function VoteTokenController(ISmartToken _token)
    SmartTokenController(_token) {}
}
