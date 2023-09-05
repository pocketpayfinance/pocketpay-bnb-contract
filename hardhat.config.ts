import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
require("dotenv").config();

const { PRIVATE_KEY } = process.env;

const config: HardhatUserConfig = {
  solidity: "0.8.19",
  networks: {
    opbnb_testnet: {
      url: `https://opbnb-testnet-rpc.bnbchain.org`,
      accounts: [`0x${PRIVATE_KEY}`],
    },
  },
};

export default config;
