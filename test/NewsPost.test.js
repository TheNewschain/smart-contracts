const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("NewsPost", function () {
  var NewsPost;
  var newsPost;
  var owner;
  var otherUsers;

  beforeEach(async () => {
    [owner, otherUsers] = await ethers.getSigners();
    NewsPost = await ethers.getContractFactory("NewsPost");
    newsPost = await NewsPost.deploy();
    await newsPost.deployed();
  });

  it("Users should be able to create posts", async function () {
    const txn1 = await newsPost.createPost("hello this is an article");
    await txn1.wait();

    const post = await newsPost.getOnePost(0);
    console.log(post);
    expect(post.content).to.equal("hello this is an article");
  });

  it("Users should be able to edit a post", async () => {
    const txn1 = await newsPost.createPost("hello this is an article");
    await txn1.wait();
    const txn2 = await newsPost.createPost("this is my second article");
    await txn2.wait();
    const txn3 = await newsPost.editPost("this is my first article", 0);
    await txn3.wait();
    const post = await newsPost.getOnePost(0);
    expect(post.content).to.equal("this is my first article");
  });
});
