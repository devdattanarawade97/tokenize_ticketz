require("@nomicfoundation/hardhat-toolbox");

require('dotenv').config();

 
//  /** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.20",
  paths: {
  
    artifacts: "./src/artifacts"
  },
  networks: {
    hardhat: {
      chainId:1337
    },
    // matic: {
    //   url:process.env.PRIVATE_ENDPOINT_URL,
    //   accounts: [process.env.PRIVATE_CONTRACT_ADDRESS_PRIVATE_KEY],
    // },
   
  }
};
