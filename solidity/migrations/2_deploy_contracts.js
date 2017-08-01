
var DepositToken = artifacts.require("DepositToken.sol");
var VoteToken = artifacts.require("VoteToken.sol");

var DepositTokenController = artifacts.require("DepositTokenController.sol");
var VoteTokenController = artifacts.require("VoteTokenController.sol");

var DepositAgent = artifacts.require("DABDepositAgent.sol");
var DAB = artifacts.require("DAB.sol");
var DAOFormula = artifacts.require("DAOFormula.sol");
var DAO = artifacts.require("DAO.sol");

var AcceptDABOwnershipProposal = artifacts.require("AcceptDABOwnershipProposal.sol");

let startTime = Math.floor(Date.now() / 1000) + 1 * 24 * 60 * 60; // crowdsale hasn't started
let endTime = Math.floor(Date.now() / 1000) + 15 * 24 * 60 * 60; // crowdsale hasn't started
let redeemTime = Math.floor(Date.now() / 1000) + 17 * 24 * 60 * 60; // crowdsale hasn't started

module.exports = async(deployer) => {
    await deployer.deploy(DAOFormula);

    await deployer.deploy(DepositToken, "Deposit Token", "DPT", 18);
    await deployer.deploy(VoteToken, "Vote Token", "VOT", 18);

    await deployer.deploy(DepositTokenController, DepositToken.address);
    await deployer.deploy(VoteTokenController, VoteToken.address);

    await deployer.deploy(DepositAgent, DepositTokenController.address);
    await deployer.deploy(DAB, DepositAgent.address);
    await deployer.deploy(DAO, DAB.address, DAOFormula.address);
    await deployer.deploy(AcceptDABOwnershipProposal, DAB.address, VoteTokenController.address, startTime, endTime, redeemTime);

};
