pragma solidity ^0.4.11;

import './interfaces/IDAB.sol';
import './interfaces/IDABDao.sol';
import './interfaces/IProposal.sol';
import './interfaces/ISmartToken.sol';
import './interfaces/IDABFormula.sol';
import './interfaces/ILoanPlanFormula.sol';
import './interfaces/IDABDaoFormula.sol';
import './Owned.sol';
import './SafeMath.sol';

contract DABDao is IDABDao, SafeMath{

    struct Proposal{
    bool isValid;
    }

    uint256 public proposalPrice;
    address[] public proposals;
    address public depositAgent;
    mapping (address => Proposal) public proposalStatus;

    ISmartToken public depositToken;
    IDAB public dab;
    IDABDaoFormula public formula;

    event LogPropose(uint256 _time, address _proposal);

    function DABDao(
    IDAB _dab,
    IDABDaoFormula _formula)
    validAddress(_dab)
    validAddress(_formula) {
        dab = _dab;
        formula = _formula;

        proposalPrice = 100 ether;
        depositAgent = dab.depositAgent();
        depositToken = dab.depositToken();
    }

    modifier validAddress(address _address){
        require(_address != 0x0);
        _;
    }

    modifier validAmount(uint256 _amount){
        require(_amount > 0);
        _;
    }

    modifier validProposal(){
        IProposal proposal = IProposal(msg.sender);
        require(proposalStatus[proposal].isValid == true);
        _;
    }

    modifier validVote(IProposal _proposal){
        require(proposalStatus[_proposal].isValid == true);
        _;
    }

    modifier dao(uint256 _threshold){
        require(_threshold <= 100 && _threshold >= 50);
        uint256 vote = depositToken.balanceOf(msg.sender);
        uint256 supply = depositToken.totalSupply();
        uint256 balance = depositToken.balanceOf(depositAgent);
        uint256 circulation = safeSub(supply, balance);
        bool isApproved = formula.isApproved(circulation, vote, _threshold);
        require(isApproved);
        _;
    }

    function propose(IProposal _proposal)
    public
    validAddress(_proposal) {
        require(msg.sender == address(_proposal));
        _proposal.acceptOwnership();
        assert(depositToken.transferFrom(_proposal, depositAgent, proposalPrice));
        proposals.push(_proposal);
        proposalStatus[_proposal].isValid = true;
        LogPropose(now, _proposal);
    }

    function vote(IProposal _proposal, uint256 _voteAmount)
    public
    validAddress(_proposal)
    validAmount(_voteAmount)
    validVote(_proposal) {
        assert(depositToken.transferFrom(msg.sender, _proposal, _voteAmount));
        _proposal.vote(msg.sender, _voteAmount);
    }

    function setDABFormula()
    public
    validProposal
    dao(80) {
        IProposal proposal = IProposal(msg.sender);
        address proposalContract = proposal.proposalContract();
        IDABFormula formula = IDABFormula(proposalContract);
        dab.setDABFormula(formula);
        proposalStatus[proposal].isValid = false;
    }

    function addLoanPlanFormula()
    public
    validProposal
    dao(80) {
        IProposal proposal = IProposal(msg.sender);
        address proposalContract = proposal.proposalContract();
        ILoanPlanFormula formula = ILoanPlanFormula(proposalContract);
        dab.addLoanPlanFormula(formula);
        proposalStatus[proposal].isValid = false;
    }

    function disableLoanPlanFormula()
    public
    validProposal
    dao(80) {
        IProposal proposal = IProposal(msg.sender);
        address proposalContract = proposal.proposalContract();
        ILoanPlanFormula formula = ILoanPlanFormula(proposalContract);
        dab.disableLoanPlanFormula(formula);
        proposalStatus[proposal].isValid = false;
    }

    function transferDABOwnership()
    public
    validProposal
    dao(80) {
        IProposal proposal = IProposal(msg.sender);
        address proposalContract = proposal.proposalContract();
        dab.transferOwnership(proposalContract);
        proposalStatus[proposal].isValid = false;
    }

    function acceptDABOwnership()
    public
    validProposal
    dao(50) {
        IProposal proposal = IProposal(msg.sender);
        dab.acceptOwnership();
        proposalStatus[proposal].isValid = false;
    }

}
