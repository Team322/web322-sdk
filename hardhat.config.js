require("@nomicfoundation/hardhat-toolbox");

const config = require('./config.js');

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.18",
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
    },
    sepolia: {
      url: config.sepolia.http,
      accounts: [config.account],
      // accounts: [privateKey1, privateKey2, ...]
    },
    polygon: {
      url: config.polygon.http,
      accounts: [config.account],
      // accounts: [privateKey1, privateKey2, ...]
    },
  },
};
