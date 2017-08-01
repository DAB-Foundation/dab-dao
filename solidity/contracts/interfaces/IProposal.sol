pragma solidity ^0.4.11;

import '../Owned.sol';

contract IProposal is Owned{
    address public proposalContract;
    function propose() public {}
    function vote(address _voter, uint256 _voteAmount) public {}
    function execute() public {}
    function redeem() public {}
}
