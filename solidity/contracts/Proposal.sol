pragma solidity ^0.4.0;

import './interfaces/IProposal.sol';
import './interfaces/ISmartToken.sol';
import './Owned.sol';
import './SafeMath.sol';
import './DAO.sol';
import './SmartTokenController.sol';

contract Proposal is Owned, IProposal, SafeMath{

    uint256 public startTime;
    uint256 public endTime;
    uint256 public redeemTime;
    uint256 public depositBalance;

    DAO public dao;
    ISmartToken public depositToken;
    ISmartToken public voteToken;
    SmartTokenController public voteTokenController;

    function AcceptDABOwnershipProposal(
    DAO _dao,
    SmartTokenController _voteTokenController,
    uint256 _startTime,
    uint256 _endTime,
    uint256 _redeemTime){
        dao = _dao;
        depositToken = dao.depositToken();
        voteTokenController = _voteTokenController;

        startTime = _startTime;
        endTime = _endTime;
        redeemTime = _redeemTime;

        depositBalance = 0;
        voteToken = _voteTokenController.token();
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

    function vote(address _voter, uint256 _voteAmount)
    public
    voteStage
    {
        voteTokenController.issueTokens(_voter, _voteAmount);
        depositBalance = safeAdd(depositBalance, _voteAmount);
    }

    function execute() public excuteStage {
        // do some real change to dao
    }

    function redeem() public redeemStage {
        uint256 amount = voteToken.balanceOf(msg.sender);
        require(amount > 0);
        voteTokenController.destroyTokens(msg.sender, amount);
        depositToken.transfer(msg.sender, amount);
    }


}
