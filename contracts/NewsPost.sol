//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/*
 *@title NewsPost
 *@dev for adding new news posts
 */
contract NewsPost is ReentrancyGuard {
  address public user;
  using Counters for Counters.Counter;
  Counters.Counter public _postId;
  struct Post {
    uint256 postId;
    string content;
    uint256 publishedTime;
    address publisher;
  }

  mapping(uint256 => Post) public IdToPost; //for mapping over all the post structs

  /*
   *@dev to create new news post
   *@param _content hash id of the uploaded article from IPFS
   */
  function createPost(string memory _content) public nonReentrant {
    uint256 currentId = _postId.current();
    Post memory post = Post(currentId, _content, block.timestamp, msg.sender);
    IdToPost[currentId] = post;
    _postId.increment();
  }

  /*
   *@dev to edit an existing post
   *@param _content hash id of the updated content
                    postId id of the post to be edited
   */
  function editPost(string memory _content, uint256 postId)
    public
    nonReentrant
  {
    Post storage post = IdToPost[postId];
    require(post.publisher == msg.sender, "You can't edit other's posts");
    post.content = _content;
    post.postId = postId;
    post.publishedTime = block.timestamp;
    post.publisher = msg.sender;
    IdToPost[postId] = post;
  }

  /*
   *@dev to fetch all the posts of a particular user
   *@return array of posts for a particular user
   */
  function fetchMyPosts() public view returns (Post[] memory) {
    uint256 currentId = _postId.current();
    Post[] memory posts = new Post[](currentId);
    uint256 currentIndex = 0;
    for (uint256 i = 0; i < currentId; i++) {
      if (IdToPost[i].publisher == msg.sender) {
        uint256 currentPostId = IdToPost[i].postId;
        Post storage currentPost = IdToPost[currentPostId];
        posts[currentIndex] = currentPost;
        currentIndex++;
      }
    }
    return posts;
  }

  /*
   *@dev get a specific post based on the Id
   *@param postId id of a specific post
   *@return a single post based on its Id
   */
  function getOnePost(uint256 postId) public view returns (Post memory) {
    return IdToPost[postId];
  }
}
