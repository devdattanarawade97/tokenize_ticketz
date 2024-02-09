// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
import hre from "hardhat";



try {

  const eventNFTContract = await ethers.getContractFactory("EventNFT");
  const eventNFT = await eventNFTContract.deploy();
  await eventNFT.waitForDeployment();
  console.log(
     `eventNFT token deployed at ${await eventNFT.target}`
  );

  const tokenTicketzNFTContract = await ethers.getContractFactory("TokenTicketzNFT");
  const tokenTicketzNFT = await tokenTicketzNFTContract.deploy();
  await tokenTicketzNFT.waitForDeployment();
  console.log(
    ` tokenTicketzNFT token deployed at ${await tokenTicketzNFT.target}`
  );


  const eventTokenAddress = await eventNFT.target;
  const ticketTokenAddress = await tokenTicketzNFT.target;
  const tokenTicketzContract = await ethers.getContractFactory("TokenTicketz");
  const tokenTicketz= await tokenTicketzContract.deploy(ticketTokenAddress ,eventTokenAddress);

  await tokenTicketz.waitForDeployment();
  
  console.log(
  `tokenTicketz contract deployed at ${await tokenTicketz.target}`
);

} catch (error) {
  
  console.log(`error occured : ${error.message}`);
}



