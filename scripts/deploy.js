const hre = require("hardhat");

async function main() {

  const Epocket = await hre.ethers.getContractFactory("Epocket");
  const epocket = await Epocket.deploy();

  await epocket.deployed();

  console.log(
    `Epocket deployed to ${epocket.address}`
  );
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
