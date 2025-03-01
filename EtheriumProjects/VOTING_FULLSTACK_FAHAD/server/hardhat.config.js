require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.28",
  networks: {
    ganache: {
      url: "HTTP://127.0.0.1:7545",
      account: "0x50a691f09daeeb32023e16a6a8f73317bb790c4656b21dd3662d223b98704666"
    }
  }
};
