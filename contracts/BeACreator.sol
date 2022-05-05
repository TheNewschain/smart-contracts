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
    string bio;
    string profilePhoto;
    string coverPhoto;
  }

  mapping(address => bool) public isCreator; // To check if a user already has an account
  mapping(uint256 => Profile) public userIdToProfile; // To save newly created accounts

  /*
   * @dev to create a new creator account
   * @param _email the email id of creator
   *               _socialMedia the social media link of the creator
   *               _personalSite any personal website link
   *              _bio creator's short bio
   *              _profilePhoto creator's profile photo
   *              _coverPhoto creator's cover photo or bussiness logo
   */
  function createProfile(
    string memory _email,
    string memory _socialMedia,
    string memory _personalSite,
    string memory _bio,
    string memory _profilePhoto,
    string memory _coverPhoto
  ) public nonReentrant {
    require(!isCreator[msg.sender], "user already exists");
    uint256 currentId = userId.current();
    userIdToProfile[currentId] = Profile(
      currentId,
      _email,
      _socialMedia,
      _personalSite,
      msg.sender,
      _bio,
      _profilePhoto,
      _coverPhoto
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

  /*
   *@dev to update profile info
   * @param _email the email id of creator
   *               _socialMedia the social media link of the creator
   *               _personalSite any personal website link
   *              _bio creator's short bio
   *              _profilePhoto creator's profile photo
   *              _coverPhoto creator's cover photo or bussiness logo
   */
  function updateProfile(
    string memory _email,
    string memory _socialMedia,
    string memory _personalSite,
    string memory _bio,
    string memory _profilePhoto,
    string memory _coverPhoto
  ) public {
    require(isCreator[msg.sender], "user already exists");
    uint256 currentId = userId.current();
    Profile memory profile;
    uint256 profileId;
    for (uint256 i = 0; i < currentId; i++) {
      if (userIdToProfile[i].walletAddress == msg.sender) {
        profile = userIdToProfile[i];
        profileId = i;
        break;
      }
    }
    require(
      profile.walletAddress == msg.sender,
      "This is not your profile You can edit it"
    );
    profile.userId = profileId;
    profile.emailId = _email;
    profile.socialMedia = _socialMedia;
    profile.personalWebsite = _personalSite;
    profile.walletAddress = msg.sender;
    profile.bio = _bio;
    profile.profilePhoto = _profilePhoto;
    profile.coverPhoto = _coverPhoto;
    userIdToProfile[profileId] = profile;
  }
}
