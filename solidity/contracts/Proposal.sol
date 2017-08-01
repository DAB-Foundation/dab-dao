pragma solidity ^0.4.11;

import './interfaces/IProposal.sol';
import './interfaces/ISmartToken.sol';
import './Owned.sol';
import './SafeMath.sol';
import './DAO.sol';
import './SmartTokenController.sol';

contract Proposal is IProposal, Owned, SafeMath{

    address public proposalContract;
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
    address _proposalContract,
    uint256 _startTime,
    uint256 _endTime,
    uint256 _redeemTime)
    validAddress(_dao)
    validAddress(_voteTokenController){
        require(now < _startTime);
        require(_startTime < _endTime);
        require(_endTime < _redeemTime);

        dao = _dao;
        voteTokenController = _voteTokenController;
        proposalContract = _proposalContract;
        startTime = _startTime;
        endTime = _endTime;
        redeemTime = _redeemTime;

        depositToken = dao.depositToken();
        voteToken = _voteTokenController.token();
        proposalPrice = dao.proposalPrice();
    }

    modifier validAddress(address _address){
        require(_address != 0x0);
        _;
    }

    modifier validAmount(uint256 _amount){
        require(_amount > 0);
        _;
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

    function acceptVoteTokenControllerOwnership() public ownerOnly{
        voteTokenController.acceptOwnership();
    }

    function getProposalContract() public ownerOnly returns (address){
        return proposalContract;
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
