require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: "0.8.26",
  networks: {
    holesky: {
      url: process.env.ALCHEMY_HOLESKY_RPC_URL || "",
      accounts: process.env.METAMASK_PRIVATE_KEY ? [process.env.METAMASK_PRIVATE_KEY] : [],
    },
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
};
