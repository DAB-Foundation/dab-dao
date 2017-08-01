pragma solidity ^0.4.11;

import './interfaces/IProposal.sol';
import './interfaces/ISmartToken.sol';
import './DAB.sol';
import './DAOFormula.sol';
import './DABDepositAgent.sol';
import './Owned.sol';
import './Math.sol';

contract DAO is Owned, DAOFormula{

    struct Proposal{
    bool isValid;
    }

    ISmartToken public depositToken;
    DABDepositAgent public depositAgent;
    DAB public dab;
    DAOFormula public formula;

    bool public isActive;

    uint256 public proposalPrice = 1000 ether;
    address[] public proposals;
    mapping (address => Proposal) public proposalStatus;
    mapping (address => mapping (address => uint256)) public votes;

    function DAO(
    DAB _dab,
    DAOFormula _formula){
        dab = _dab;
        formula = _formula;

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

    modifier dao(uint256 _supportRate){
        uint256 vote = depositToken.balanceOf(msg.sender);
        uint256 supply = depositToken.totalSupply();
        uint256 balance = depositToken.balanceOf(depositAgent);
        uint256 circulation = safeSub(supply, balance);
        bool isApproved = formula.isApproved(circulation, vote, _supportRate);
        require(isApproved);
        _;
    }

    function activate() ownerOnly{
        transferOwnership(this);
        acceptOwnership();
        isActive = true;
    }

    function propose(IProposal _proposal)
    validAddress(_proposal) {
        require(msg.sender == address(_proposal));
        _proposal.acceptOwnership();
        depositToken.transferFrom(_proposal, depositAgent, proposalPrice);
        proposals.push(_proposal);
        proposalStatus[_proposal].isValid = true;
    }

    function transferDABOwnership()
    validProposal
    dao(80)
    {
        IProposal proposal = IProposal(msg.sender);
        address proposalContract = proposal.proposalContract();
        dab.transferOwnership(proposalContract);
    }

    function setDABFormula()
    validProposal
    dao(80)
    {
        IProposal proposal = IProposal(msg.sender);
        address proposalContract = proposal.proposalContract();
        dab.setDABFormula(proposalContract);

    }


    function addLoanPlanFormula()
    validProposal
    dao(80)
    {
        IProposal proposal = IProposal(msg.sender);
        address proposalContract = proposal.proposalContract();
        dab.addLoanPlanFormula(proposalContract);
    }

    function disableLoanPlanFormula()
    validProposal
    dao(80)
    {
        IProposal proposal = IProposal(msg.sender);
        address proposalContract = proposal.proposalContract();
        dab.disableLoanPlanFormula(proposalContract);
    }

    function vote(IProposal _proposal, uint256 _voteAmount)
    public
    validAddress(_proposal)
    validAmount(_voteAmount)
    validProposal {
        depositToken.transferFrom(msg.sender, _proposal, _voteAmount);
        _proposal.vote(msg.sender, _voteAmount);
        votes[msg.sender][_proposal] = safeAdd(votes[msg.sender][_proposal], _voteAmount);
    }

    function acceptDABOwnership()
    validProposal
    dao(50)
    {
        dab.acceptOwnership();
    }


}
