const hre = require("hardhat");
require("dotenv").config();

async function main() {
    const [deployer] = await hre.ethers.getSigners();
    console.log(`Deploying contract with the account: ${deployer.address}`);

    const Vote = await hre.ethers.getContractFactory("Vote");
    const vote = await Vote.deploy();
    
    await vote.deployed();

    console.log(`Vote contract deployed at: ${vote.address}`);

    // Optional: Log transaction details
    console.log("Transaction hash:", vote.deployTransaction.hash);
    console.log("Gas used:", (await vote.deployTransaction.wait()).gasUsed.toString());
}

main().catch((error) => {
    console.error("Error deploying contract:", error);
    process.exitCode = 1;
});
