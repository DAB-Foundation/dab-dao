
## DAB DAO
### What is it
DAB DAO is Decentralized Autonomous Bank DAO. It is to redistribute and allocate the authorities and votes to the holders of all deposit tokens(DPT).

### Why
#### Goal
Democratic vote to execute the privilege functions.

Needs to achieve
1. Need to be able to update the contracts: mainly formulas.
2. Need more than 80% of the support rate to be able to modify DAB's ownership(Move to another DABDao).
3. Need more than 80% of the support rate to be able to modify formulas.
4. Need more than 50% support to be able to accept  DAB's ownership(to be autonomous).

### How
#### Implementation
A proposal contract that implements the Proposal Abstract Class, which can be run privilege functions on DABDao after gaining a support rate that exceeds the threshold, and then upgrades the original contract.

In the process of voting, the voting DPT will be converted into a temporary Vote Token(VOT), and this token is controlled by the Proposal Contract, the voters can redeem their DPT after the proposal ended, ether succeeds or fails.

If a proposal contract want to execute the DABDao privilege function, then the proposal needs to have a certain proportion of DPT. Such a mechanism can avoid the voters vote twice.

#### Steps
1. The first step is to implement an proposal contract for a specific goal, set the duration and the target DABDao function and the new proposed replacement contract.
2. And then the propose the contract to the DABDao Contract, the process needs to transfer a certain amount of deposit token from the proposal contract to the DepositAgent to avoid misuse of `propose` function in the DABDao Contract.
3. After the proposal contract proposed, voters can vote the proposal by `vote` function of the DABDao Contract, each DPT is a vote.
4. If the amount of votes in this proposal reaches the threshold that can execute the target privilege function in DABDao before vote stage ended, then the function on the DABDao can be executed. Otherwise, it fails.  either the proposal fails or succeeds, it will enter the redeem stage.

### Test


Tests are included and can be run on using [truffle](https://github.com/trufflesuite/truffle) and [testrpc](https://github.com/ethereumjs/testrpc).

    brew install npm
    npm install -g truffle
    npm install -g ethereumjs-testrpc

#### Prerequisites

    node v8.1.3+
    npm v5.3.0+
    truffle v3.4.5+
    testrpc v4.0.1+




##### Testrpc

Test in the development period.

To run the test, execute the following commands from the project's root folder.

    npm start
    npm test