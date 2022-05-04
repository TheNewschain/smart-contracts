//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/*
 *@title BeACreator
 *@dev for signing up as a creator
 */
contract BeACreator is ReentrancyGuard {
  using Counters for Counters.Counter;
  Counters.Counter public userId;

  // To store creators' profile information
  struct Profile {
    uint256 userId;
    string emailId;
    string socialMedia;
    string personalWebsite;
    address walletAddress;
  }

  mapping(address => bool) public isCreator; // To check if a user already has an account
  mapping(uint256 => Profile) public userIdToProfile; // To save newly created accounts

  /*
   * @dev to create a new creator account
   * @param _email the email id of creator
   *               _socialMedia the social media link of the creator
   *               _personalSite any personal website link
   */
  function createProfile(
    string memory _email,
    string memory _socialMedia,
    string memory _personalSite
  ) public nonReentrant {
    require(!isCreator[msg.sender], "user already exists");
    uint256 currentId = userId.current();
    userIdToProfile[currentId] = Profile(
      currentId,
      _email,
      _socialMedia,
      _personalSite,
      msg.sender
    );
    isCreator[msg.sender] = true;
    userId.increment();
  }

  /*
   *@dev fetches the profile info of content creators
   *@return profile struct of the caller address
   */
  function fetchProfile() public view returns (Profile memory) {
    require(isCreator[msg.sender], "This creator does not exist");
    uint256 currentId = userId.current();
    Profile memory profile;
    for (uint256 i = 0; i < currentId; i++) {
      if (userIdToProfile[i].walletAddress == msg.sender) {
        profile = userIdToProfile[i];
      }
    }
    return profile;
  }
}
