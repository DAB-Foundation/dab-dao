pragma solidity ^0.4.0;


contract IProposal{
    address public proposalContract;
    function vote(address _voter, uint256 _voteAmount) public {}
    function execute() public {}
    function redeem() public {}
}
