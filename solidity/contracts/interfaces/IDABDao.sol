pragma solidity ^0.4.11;

import './IOwned.sol';
import './IProposal.sol';
import './ISmartToken.sol';

contract IDABDao is IOwned{

    function activate();

    function freeze();

    function depositToken() public constant returns (ISmartToken depositToken){depositToken;}

    function proposalPrice() public constant returns (uint256 proposalPrice) {proposalPrice;}

    function propose(IProposal proposal) public;

    function transferDABOwnership() public;

    function setDABFormula() public;

    function addLoanPlanFormula() public;

    function disableLoanPlanFormula() public;

    function vote(IProposal proposal, uint256 voteAmount) public;

    function acceptDABOwnership() public;

}
