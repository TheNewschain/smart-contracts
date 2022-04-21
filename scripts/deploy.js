const hre = require("hardhat");

async function main() {
  const [owner, otherUser] = await ethers.getSigners();
  const NewsPost = await hre.ethers.getContractFactory("NewsPost");
  const newsPost = await NewsPost.deploy();
  await newsPost.deployed();
  console.log("NewsPost deployed to:", newsPost.address);

  const txn1 = await newsPost.createPost("hello this is an article");
  await txn1.wait();
  const txn2 = await newsPost.createPost("this is my second article");
  await txn2.wait();
  const txn3 = await newsPost.editPost("this is my first article", 0);
  await txn3.wait();

  const data = await newsPost.fetchMyPosts();
  const posts = await Promise.all(
    data.map(async (i) => {
      let item = {
        postId: i.postId.toNumber(),
        content: i.content,
        publishedTime: new Date(
          i.publishedTime.toNumber() * 1000
        ).toLocaleDateString(),
        publisher: i.publisher,
      };

      return item;
    })
  );
  console.log(posts);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
