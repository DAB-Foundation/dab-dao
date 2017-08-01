pragma solidity ^0.4.11;

import './Proposal.sol';

contract AcceptDABOwnershipProposal is Proposal{


    function AcceptDABOwnershipProposal(
    DAO _dao,
    SmartTokenController _voteTokenController,
    address _proposalContract,
    uint256 _startTime,
    uint256 _endTime,
    uint256 _redeemTime)
    Proposal(_dao, _voteTokenController, _proposalContract, _startTime, _endTime, _redeemTime){
    }

    function execute() public excuteStage {
    // accept DAB ownership
        dao.acceptDABOwnership();
    }

}
