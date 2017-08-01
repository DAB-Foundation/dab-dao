pragma solidity ^0.4.0;

import './interfaces/ISmartToken.sol';
import './DABDepositAgent.sol';

contract DAB is Owned{

    bool public isActive;

    ISmartToken public depositToken;
    DABDepositAgent public depositAgent;

    function DAB(DABDepositAgent _depositAgent){
        depositAgent = _depositAgent;

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

    function transferDepositTokensFrom(address _from, address _to, uint256 _amount)
    public
    ownerOnly{
        depositAgent.transferDepositTokensFrom(_from, _to, _amount);
    }

}
