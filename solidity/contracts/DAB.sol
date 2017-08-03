pragma solidity ^0.4.11;

import './interfaces/IDAB.sol';
import './interfaces/ISmartToken.sol';
import './interfaces/IDABFormula.sol';
import './interfaces/ILoanPlanFormula.sol';
import './DABDepositAgent.sol';

contract DAB is Owned, IDAB{

    bool public isActive;
    uint256 public creditAgentActivationTime;

    ISmartToken public depositToken;
    DABDepositAgent public depositAgent;

    function DAB(
    DABDepositAgent _depositAgent,
    uint256 _activationTime){
        depositAgent = _depositAgent;
        creditAgentActivationTime = _activationTime;

        depositToken = depositAgent.depositToken();
    }

    modifier active(){
        require(isActive == true);
        _;
    }

    modifier inactive(){
        require(isActive == false);
        _;
    }

    function activate() ownerOnly{
        depositAgent.activate();
        isActive = true;
    }

/**
    @dev allows transferring the token agent ownership
    the new owner still need to accept the transfer
    can only be called by the contract owner

    @param _newOwner    new token owner
*/
    function transferDepositAgentOwnership(address _newOwner)
    public
    ownerOnly
    inactive {
        depositAgent.transferOwnership(_newOwner);
    }

    function acceptDepositAgentOwnership()
    public
    ownerOnly
    inactive {
        depositAgent.acceptOwnership();
    }

    function setDABFormula(IDABFormula _formula)
    public
    ownerOnly{
    // TODO set DAB formula
        _formula;
    }

    function addLoanPlanFormula(ILoanPlanFormula _formula)
    public
    ownerOnly{
    // TODO add loan plan formula
        _formula;
    }

    function disableLoanPlanFormula(ILoanPlanFormula _formula)
    public
    ownerOnly{
    // TODO disable loan plan formula
        _formula;
    }

}
