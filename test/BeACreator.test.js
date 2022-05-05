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

  xit("User should be able to create new profile", async function () {
    const txn1 = await creator.createProfile(
      "mishrakundan073@gmail.com",
      "https://github.com/mishra811",
      "https://linktr.ee/0xmishra",
      "I am a developer",
      "Profile photo",
      "cover photo"
    );
    await txn1.wait();

    const myProfile = await creator.fetchProfile();
    console.log(myProfile);
    expect(myProfile.emailId).to.equal("mishrakundan073@gmail.com");
  });

  it("User should be able to update their profile info", async () => {
    const txn1 = await creator.createProfile(
      "mishrakundan073@gmail.com",
      "https://github.com/mishra811",
      "https://linktr.ee/0xmishra",
      "I am an developer",
      "Profile photo",
      "cover photo"
    );
    await txn1.wait();
    let myProfile = await creator.fetchProfile();
    console.log(myProfile);

    const txn2 = await creator.updateProfile(
      "mishrakundan780@gmail.com",
      "https://github.com/mishra811",
      "https://linktr.ee/0xmishra",
      "I am an engineer",
      "Profile pic",
      "bussiness logo"
    );
    await txn2.wait();
    myProfile = await creator.fetchProfile();
    console.log(myProfile);
    expect(myProfile.emailId).to.equal("mishrakundan780@gmail.com");
  });
});
