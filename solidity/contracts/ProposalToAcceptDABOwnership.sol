pragma solidity ^0.4.11;

import './interfaces/IDABDao.sol';
import './Proposal.sol';

contract ProposalToAcceptDABOwnership is Proposal{


    function ProposalToAcceptDABOwnership(
    IDABDao _dao,
    SmartTokenController _voteTokenController,
    address _proposalContract,
    uint256 _duration)
    Proposal(_dao, _voteTokenController, _proposalContract, _duration){
    }

    function execute() public excuteStage {
    // accept DAB ownership
        dao.acceptDABOwnership();
    }

}
