pragma solidity ^0.4.11;

import './interfaces/ISmartToken.sol';
import './SmartTokenController.sol';
import './Owned.sol';
import './SafeMath.sol';

contract DABDepositAgent is Owned, SafeMath{


    bool public isActive;
    uint256 public depositBalance;

    ISmartToken public depositToken;
    SmartTokenController public depositTokenController;

    event LogVote(address _voter, address _proposal, uint256 _voteAmount);


    function DABDepositAgent(
    SmartTokenController _depositTokenController)
    validAddress(_depositTokenController)
    {
        depositTokenController = _depositTokenController;

        depositBalance = 0;
        isActive = false;
        depositToken = depositTokenController.token();
    }

    modifier validAddress(address _address){
        require(_address != 0x0);
        _;
    }

    modifier validAmount(uint256 _amount){
        require(_amount > 0);
        _;
    }

    modifier inactive(){
        require(!isActive);
        _;
    }

    function activate()
    public
    ownerOnly{
        isActive = true;
    }

    function freeze()
    public
    ownerOnly{
        isActive = false;
    }

/**
    @dev allows transferring the token controller ownership
    the new owner still need to accept the transfer
    can only be called by the contract owner

    @param _newOwner    new token owner
*/
    function transferDepositTokenControllerOwnership(address _newOwner)
    public
    ownerOnly
    inactive {
        depositTokenController.transferOwnership(_newOwner);
    }

/**
    @dev used by a new owner to accept a token controller ownership transfer
    can only be called by the contract owner
*/
    function acceptDepositTokenControllerOwnership()
    public
    ownerOnly
    inactive {
        depositTokenController.acceptOwnership();
    }

}
