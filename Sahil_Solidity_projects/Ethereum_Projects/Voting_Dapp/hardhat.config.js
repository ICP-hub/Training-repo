require("@nomicfoundation/hardhat-toolbox");

module.exports = {
  solidity: "0.8.28",
  networks: {
    hardhat: {
      chainId: 31337,  // Ensures consistency when using Hardhat's local blockchain
    },
    localhost: {
      url: "http://127.0.0.1:8545",  // Connects to Hardhat node
      chainId: 31337,
    },
  },
  paths: {
    artifacts: "./artifacts",
    sources: "./contracts",
    cache: "./cache",
    tests: "./test",
  },
};
