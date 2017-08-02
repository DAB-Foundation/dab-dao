pragma solidity ^0.4.11;

import './interfaces/IDABDao.sol';
import './interfaces/IProposal.sol';
import './interfaces/ISmartToken.sol';
import './interfaces/IDABFormula.sol';
import './interfaces/ILoanPlanFormula.sol';
import './interfaces/IDABDaoFormula.sol';
import './Owned.sol';
import './SafeMath.sol';
import './DAB.sol';
import './DABDepositAgent.sol';

contract DABDao is Owned, IDABDao, SafeMath{

    struct Proposal{
    bool isValid;
    }

    bool public isActive;
    uint256 public proposalPrice = 1000 ether;
    uint256 public creditAgentActivationTime;
    address[] public proposals;
    mapping (address => Proposal) public proposalStatus;
    mapping (address => mapping (address => uint256)) public votes;

    ISmartToken public depositToken;
    DABDepositAgent public depositAgent;
    DAB public dab;
    IDABDaoFormula public formula;

    function DABDao(
    DAB _dab,
    IDABDaoFormula _formula){
        dab = _dab;
        formula = _formula;

        isActive = false;
        creditAgentActivationTime = dab.creditAgentActivationTime();
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

    modifier active(){
        require(isActive == true);
        _;
    }

    modifier inactive(){
        require(isActive == false);
        _;
    }

    modifier validProposal(){
        IProposal proposal = IProposal(msg.sender);
        address _owner = proposal.owner();
        require(_owner == address(this));
        require(proposalStatus[proposal].isValid);
        _;
    }

// ensures that credit contract activated
    modifier activeCreditAgent() {
        require(now > creditAgentActivationTime);
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

    function activate() ownerOnly activeCreditAgent{
        isActive = true;
    }

    function freeze() ownerOnly activeCreditAgent{
        isActive = false;
    }

    function propose(IProposal _proposal)
    public
    active
    validAddress(_proposal) {
        require(msg.sender == address(_proposal));
        _proposal.acceptOwnership();
        depositToken.transferFrom(_proposal, depositAgent, proposalPrice);
        proposals.push(_proposal);
        proposalStatus[_proposal].isValid = true;
    }

    function transferDABOwnership()
    public
    active
    validProposal
    dao(80) {
        IProposal proposal = IProposal(msg.sender);
        address proposalContract = proposal.proposalContract();
        dab.transferOwnership(proposalContract);
    }

    function setDABFormula()
    public
    active
    validProposal
    dao(80) {
        IProposal proposal = IProposal(msg.sender);
        address proposalContract = proposal.proposalContract();
        IDABFormula formula = IDABFormula(proposalContract);
        dab.setDABFormula(formula);

    }

    function addLoanPlanFormula()
    public
    active
    validProposal
    dao(80) {
        IProposal proposal = IProposal(msg.sender);
        address proposalContract = proposal.proposalContract();
        ILoanPlanFormula formula = ILoanPlanFormula(proposalContract);
        dab.addLoanPlanFormula(formula);
    }

    function disableLoanPlanFormula()
    public
    active
    validProposal
    dao(80) {
        IProposal proposal = IProposal(msg.sender);
        address proposalContract = proposal.proposalContract();
        ILoanPlanFormula formula = ILoanPlanFormula(proposalContract);
        dab.disableLoanPlanFormula(formula);
    }

    function vote(IProposal _proposal, uint256 _voteAmount)
    public
    active
    validAddress(_proposal)
    validAmount(_voteAmount)
    validProposal {
        depositToken.transferFrom(msg.sender, _proposal, _voteAmount);
        _proposal.vote(msg.sender, _voteAmount);
        votes[msg.sender][_proposal] = safeAdd(votes[msg.sender][_proposal], _voteAmount);
    }

    function acceptDABOwnership()
    public
    active
    validProposal
    dao(50)
    {
        dab.acceptOwnership();
    }


}
