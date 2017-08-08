pragma solidity ^0.4.11;

import './interfaces/IProposal.sol';
import './interfaces/ISmartToken.sol';
import './interfaces/IDABDao.sol';
import './Owned.sol';
import './SafeMath.sol';
import './SmartTokenController.sol';

contract Proposal is IProposal, Owned, SafeMath{

    address public proposalContract;
    uint256 public startTime;
    uint256 public endTime;

    uint256 public proposalPrice;

    IDABDao public dao;
    ISmartToken public depositToken;
    ISmartToken public voteToken;
    SmartTokenController public voteTokenController;

    function Proposal(
    IDABDao _dao,
    SmartTokenController _voteTokenController,
    address _proposalContract,
    uint256 _duration)
    validAddress(_dao)
    validAddress(_voteTokenController)
    validAmount(_duration) {

        dao = _dao;
        voteTokenController = _voteTokenController;
        proposalContract = _proposalContract;
        startTime = now + 1 days;
        endTime = startTime + _duration;

        depositToken = dao.depositToken();
        proposalPrice = dao.proposalPrice();
        voteToken = voteTokenController.token();
    }

    modifier validAddress(address _address){
        require(_address != 0x0);
        _;
    }

    modifier validAmount(uint256 _amount){
        require(_amount > 0);
        _;
    }

    modifier proposeStage(){
        require(now < startTime);
        _;
    }

    modifier voteStage(){
        require(now > startTime && now < endTime);
        _;
    }

    modifier excuteStage(){
        require(now > startTime);
        _;
    }

    modifier redeemStage(){
        require(now > startTime);
        _;
    }

    function acceptVoteTokenControllerOwnership() public ownerOnly{
        voteTokenController.acceptOwnership();
    }

    function propose() public ownerOnly proposeStage{
        uint256 voteTokenSupply = voteToken.totalSupply();
        require(voteTokenSupply == 0);
        depositToken.approve(dao, proposalPrice);
        transferOwnership(dao);
        dao.propose(this);
        startTime = now;
    }

    function vote(address _voter, uint256 _voteAmount)
    public
    ownerOnly
    voteStage
    validAddress(_voter)
    validAmount(_voteAmount)
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
