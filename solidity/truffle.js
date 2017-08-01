module.exports = {
  networks: {
    testrpc: {
      host: "localhost",
      port: 8545,
      network_id: "10", // Match network id = 10
      gas: 3000000
    },
    testnet: {
      host: "localhost",
      port: 8545,
      network_id: "3", // Match network id = 3
      gas: 3000000
    }
  }
};
