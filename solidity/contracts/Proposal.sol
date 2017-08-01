pragma solidity ^0.4.11;

import './interfaces/IProposal.sol';
import './interfaces/ISmartToken.sol';
import './SafeMath.sol';
import './DAO.sol';
import './SmartTokenController.sol';

contract Proposal is IProposal, SafeMath{


    uint256 public startTime;
    uint256 public endTime;
    uint256 public redeemTime;

    uint256 public proposalPrice;

    DAO public dao;
    ISmartToken public depositToken;
    ISmartToken public voteToken;
    SmartTokenController public voteTokenController;

    function Proposal(
    DAO _dao,
    SmartTokenController _voteTokenController,
    uint256 _startTime,
    uint256 _endTime,
    uint256 _redeemTime){
        require(now < _startTime);
        require(_startTime < _endTime);
        require(_endTime < _redeemTime);

        dao = _dao;
        voteTokenController = _voteTokenController;
        startTime = _startTime;
        endTime = _endTime;
        redeemTime = _redeemTime;

        depositToken = dao.depositToken();
        voteToken = _voteTokenController.token();
        proposalPrice = dao.proposalPrice();
    }

    modifier voteStage(){
        require(now > startTime && now < endTime);
        _;
    }

    modifier excuteStage(){
        require(now > endTime && now < redeemTime);
        _;
    }

    modifier redeemStage(){
        require(now > redeemTime);
        _;
    }

    function propose() public ownerOnly{
        depositToken.approve(dao, proposalPrice);
        transferOwnership(dao);
        dao.propose(this);
    }

    function vote(address _voter, uint256 _voteAmount)
    public
    ownerOnly
    voteStage
    {
        voteTokenController.issueTokens(_voter, _voteAmount);
    }

    function redeem() public redeemStage {
        uint256 amount = voteToken.balanceOf(msg.sender);
        require(amount > 0);
        voteTokenController.destroyTokens(msg.sender, amount);
        depositToken.transfer(msg.sender, amount);
    }


}
