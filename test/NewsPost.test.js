const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("NewsPost", function () {
  it("Users should be able to create posts", async function () {
    const NewsPost = await ethers.getContractFactory("NewsPost");
    const newsPost = await NewsPost.deploy();
    await newsPost.deployed();
    const txn1 = await newsPost.createPost("hello this is an article");
    await txn1.wait();

    const post = await newsPost.getOnePost(0);
    console.log(post);
    expect(post.content).to.equal("hello this is an article");
  });
});
