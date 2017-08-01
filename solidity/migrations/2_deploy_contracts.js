
var DepositToken = artifacts.require("DepositToken.sol");
var VoteToken = artifacts.require("VoteToken.sol");

var DepositTokenController = artifacts.require("DepositTokenController.sol");
var VoteTokenController = artifacts.require("VoteTokenController.sol");

var DABDepositAgent = artifacts.require("DABDepositAgent.sol");
var DAB = artifacts.require("DAB.sol");
var DAOFormula = artifacts.require("DAOFormula.sol");
var DAO = artifacts.require("DAO.sol");

var AcceptDABOwnershipProposal = artifacts.require("AcceptDABOwnershipProposal.sol");

let startTime = Math.floor(Date.now() / 1000) + 24 * 60 * 60; // crowdsale hasn't started
let endTime = Math.floor(Date.now() / 1000) + 15 * 24 * 60 * 60; // crowdsale hasn't started
let redeemTime = Math.floor(Date.now() / 1000) + 17 * 24 * 60 * 60; // crowdsale hasn't started

let account = "0xee0714a27c93a64e504e54e25cca44dec11a856a";

module.exports = async(deployer, network) => {
    await deployer.deploy(DAOFormula);

    await deployer.deploy(DepositToken, "Deposit Token", "DPT", 18);
    await deployer.deploy(VoteToken, "Vote Token", "VOT", 18);

    await deployer.deploy(DepositTokenController, DepositToken.address);
    await deployer.deploy(VoteTokenController, VoteToken.address);

    await deployer.deploy(DABDepositAgent, DepositTokenController.address);
    await deployer.deploy(DAB, DABDepositAgent.address);
    await deployer.deploy(DAO, DAB.address, DAOFormula.address);
    await deployer.deploy(AcceptDABOwnershipProposal, DAB.address, VoteTokenController.address, '0x0', startTime, endTime, redeemTime);

    await DepositToken.deployed(async(instance) =>{
       await instance.transferOwnership(DepositTokenController.address);
    });

    await VoteToken.deployed(async(instance) =>{
        await instance.transferOwnership(VoteTokenController.address);
    });

    await DepositTokenController.deployed(async(instance) =>{
        await instance.acceptTokenOwnership();
    });

    if(network === "testnet"){
        await DepositTokenController.deployed(async(instance) =>{
            await instance.issueTokens(account, Math.pow(10, 23));
        });
    }

    await VoteTokenController.deployed(async(instance) =>{
        await instance.acceptTokenOwnership();
    });

    await DepositTokenController.deployed(async(instance) =>{
        await instance.transferOwnership(DABDepositAgent.address);
    });

    await VoteTokenController.deployed(async(instance) =>{
        await instance.transferOwnership(AcceptDABOwnershipProposal.address);
    });

    await DABDepositAgent.deployed(async(instance) =>{
        await instance.acceptDepositTokenControllerOwnership();
    });

    await AcceptDABOwnershipProposal.deployed(async(instance) =>{
        await instance.acceptVoteTokenControllerOwnership();
    });

    await DABDepositAgent.deployed(async(instance) =>{
        await instance.transferOwnership(DAB.address);
    });

    await DAB.deployed(async(instance) =>{
        await instance.acceptDepositAgentOwnership(DAB.address);
    });

    await DAB.deployed(async(instance) =>{
        await instance.transferOwnership(DAO.address);
    });

    await DAO.deployed(async(instance) =>{
        await instance.activate();
    });
};
