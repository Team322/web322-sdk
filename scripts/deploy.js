// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const adminAddr = "0xDA4e7a6E6FC5605a88Fb5768E9d92A59E8356ca5";
  const { network } = hre;
  const networkName = network.name;

  console.log(networkName)

  const fs = require('fs');
  const path = require('path');
  const filePath = path.resolve(__dirname, '..', 'deployment.json');
  const data = JSON.parse(fs.readFileSync(filePath, 'utf8'));

  console.log(data)
  console.log(data[networkName])

  const oracleAddr = data[networkName].Web322Endpoint;

  const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  const unlockTime = currentTimestampInSeconds + 60;

  const lockedAmount = hre.ethers.utils.parseEther("0.001");

  const Web322 = await hre.ethers.getContractFactory("Web322");
  const web322 = await Web322.deploy();

  await web322.deployed();

  const ChatGPTClient = await hre.ethers.getContractFactory("ChatGPTClient", { 
      libraries: {
        Web322: web322.address,
      }
  });
  const chatgptclient = await ChatGPTClient.deploy(oracleAddr, adminAddr);
  // return;
  await chatgptclient.deployed();

  // console.log(chatgptclient);

  console.log(
    `Lock with ${ethers.utils.formatEther(
      lockedAmount
    )}ETH and unlock timestamp ${unlockTime} deployed to ${chatgptclient.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
