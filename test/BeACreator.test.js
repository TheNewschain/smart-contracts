const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("BeACreator", function () {
  var Creator;
  var creator;
  var owner;
  var otherUsers;

  beforeEach(async () => {
    [owner, otherUsers] = await ethers.getSigners();
    Creator = await ethers.getContractFactory("BeACreator");
    creator = await Creator.deploy();
    await creator.deployed();
  });

  it("User should be able to create new profile", async function () {});
});
