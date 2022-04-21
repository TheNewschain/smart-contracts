const hre = require("hardhat");

async function main() {
  const NewsPost = await hre.ethers.getContractFactory("NewsPost");
  const newsPost = await NewsPost.deploy();

  await newsPost.deployed();

  console.log("NewsPost deployed to:", newsPost.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
