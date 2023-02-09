require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config()

const GOERLI_RPC_URL =process.env.GOERLI_RPC_URL;
const DEPLOYER_KEY =process.env.DEPLOYER_KEY 

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  networks: {
    goerli: {
      url: GOERLI_RPC_URL,
      accounts: [DEPLOYER_KEY],
      chainId: 5,
    }
  },
  solidity: "0.8.7",
};
