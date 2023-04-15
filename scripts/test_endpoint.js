const fs = require("fs");
const path = require("path");
const Web3 = require('web3');
const chalk = require('chalk');
const hre = require("hardhat");

const log_color_fns = [
  chalk.green,
  chalk.blue,
  chalk.yellow,
  chalk.red,
  chalk.magenta,
  chalk.cyan,
  chalk.gray,
]

const config = require('../config.js');
const deployment_info = require('../deployment.json');

const getAbi = name => {
  try {
    const dir = path.resolve(
      __dirname,
      `../artifacts/contracts/${name}.sol/${name}.json`
    );
    const file = fs.readFileSync(dir, "utf8");
    const json = JSON.parse(file);
    const abi = json.abi;
    // console.log(`abi`, abi)

    return abi;
  } catch (e) {
    console.log(`e`, e)
  }
}
  
const makeRequest = async (contract) => {
  console.log(`making a request ${contract}`);
  console.log(`methods: ${contract.methods}`)
  // Syntax: contract.methods.<methodname>
  r = await contract.methods.requestUnicorn().send({gas: 1000000, value: '1000000000000'});
  // console.log(r);
}

const makeContract = async (network, new_log) => {
  const log = new_log;
  
  log(`start monitoring contract: ${config[network].prefix}${deployment_info[network]['ChatGPTClient']}`);

  const web3 = new Web3(config[network].ws);
  const Contract = web3.eth.Contract;

  const account = web3.eth.accounts.privateKeyToAccount('0x'+config.account);
  web3.eth.accounts.wallet.add(account);

  const contract = new Contract(getAbi('ChatGPTClient'), deployment_info[network]['ChatGPTClient'], {
    from: account.address,
  });
  return contract;
}

async function main() {
  const network = hre.network.name;
  // console.log(networkDict);
  // const network = networkDict["name"];
  console.log(network)
  const f = log_color_fns[0];
  const contract = await makeContract(network, function (...args) {
    console.log(`[${f(network)}]`.padEnd(25, ' '), ...args);
  });

  makeRequest(contract)
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

