
var DepositToken = artifacts.require("DepositToken.sol");
var VoteToken = artifacts.require("VoteToken.sol");

var DepositTokenController = artifacts.require("DepositTokenController.sol");
var VoteTokenController = artifacts.require("VoteTokenController.sol");

var DABDepositAgent = artifacts.require("DABDepositAgent.sol");
var DAB = artifacts.require("DAB.sol");
var DAOFormula = artifacts.require("DABDaoFormula.sol");
var DAO = artifacts.require("DABDao.sol");

var ProposalToAcceptDABOwnership = artifacts.require("ProposalToAcceptDABOwnership.sol");

let startTime = Math.floor(Date.now() / 1000) // crowdsale hasn't started
let duration = 30 * 24 * 60 * 60; // crowdsale hasn't started

let account = "0xee0714a27c93a64e504e54e25cca44dec11a856a";

module.exports = async(deployer, network) => {

    await deployer.deploy(DAOFormula);

    await deployer.deploy(DepositToken, "Deposit Token", "DPT", 18);
    await deployer.deploy(VoteToken, "Vote Token", "VOT", 18);

    await deployer.deploy(DepositTokenController, DepositToken.address);
    await deployer.deploy(VoteTokenController, VoteToken.address);

    await deployer.deploy(DABDepositAgent, DepositTokenController.address);
    await deployer.deploy(DAB, DABDepositAgent.address, startTime);
    await deployer.deploy(DAO, DAB.address, DAOFormula.address);

    await deployer.deploy(ProposalToAcceptDABOwnership, DAO.address, VoteTokenController.address, '0x0', duration);


    await DepositToken.deployed().then(async(instance) =>{
       await instance.transferOwnership(DepositTokenController.address);
    });

    await VoteToken.deployed().then(async(instance) =>{
        await instance.transferOwnership(VoteTokenController.address);
    });

    await DepositTokenController.deployed().then(async(instance) =>{
        await instance.acceptTokenOwnership();
    });


    await VoteTokenController.deployed().then(async(instance) =>{
        await instance.acceptTokenOwnership();
    });

    await DepositTokenController.deployed().then(async(instance) =>{
        await instance.transferOwnership(DABDepositAgent.address);
    });

    await VoteTokenController.deployed().then(async(instance) =>{
        await instance.transferOwnership(ProposalToAcceptDABOwnership.address);
    });

    await DABDepositAgent.deployed().then(async(instance) =>{
        await instance.acceptDepositTokenControllerOwnership();
    });

    await ProposalToAcceptDABOwnership.deployed().then(async(instance) =>{
        await instance.acceptVoteTokenControllerOwnership();
    });

    await DABDepositAgent.deployed().then(async(instance) =>{
        await instance.transferOwnership(DAB.address);
    });

    await DAB.deployed().then(async(instance) =>{
        await instance.acceptDepositAgentOwnership(DAB.address);
    });

    await DAB.deployed().then(async(instance) =>{
        await instance.transferOwnership(DAO.address);
    });


};
