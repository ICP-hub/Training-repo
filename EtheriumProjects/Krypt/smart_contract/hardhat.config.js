// https://eth-goerli.g.alchemy.com/v2/iF3TWvfH8AqMeh1O90LB2xM9K78CjkEQ

require('@nomiclabs/hardhat-waffle');

module.exports = {
  solidity: "0.8.0",
  networks: {
    holesky: {
      url: "https://eth-holesky.g.alchemy.com/v2/oY1GAWTBHTROPdmZQGKYnI1HMjRpWUe4",
      accounts: [
        "2f06ce93974ef0f0f407dc694923c27340eaa9c471243dfd91684eddfac34684",
      ],
    },
  },
};