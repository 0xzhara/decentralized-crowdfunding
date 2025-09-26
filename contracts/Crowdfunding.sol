// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Decentralized Crowdfunding Platform
/// @notice Users can create campaigns, donate ETH, and withdraw funds if goal is reached
contract Crowdfunding {
    struct Campaign {
        address creator;
        string title;
        uint256 goal;
        uint256 deadline;
        uint256 raised;
        bool withdrawn;
    }

    uint256 public campaignCount;
    mapping(uint256 => Campaign) public campaigns;
    mapping(uint256 => mapping(address => uint256)) public donations;

    event CampaignCreated(uint256 id, address creator, string title, uint256 goal, uint256 deadline);
    event DonationReceived(uint256 id, address donor, uint256 amount);
    event FundsWithdrawn(uint256 id, uint256 amount);

    /// @notice Create a new crowdfunding campaign
    function createCampaign(string memory _title, uint256 _goal, uint256 _duration) public {
        require(_goal > 0, "Goal must be greater than zero");
        require(_duration > 0, "Duration must be greater than zero");

        campaignCount++;
        campaigns[campaignCount] = Campaign({
            creator: msg.sender,
            title: _title,
            goal: _goal,
            deadline: block.timestamp + _duration,
            raised: 0,
            withdrawn: false
        });

        emit CampaignCreated(campaignCount, msg.sender, _title, _goal, block.timestamp + _duration);
    }

    /// @notice Donate ETH to a campaign
    function donate(uint256 _id) public payable {
        Campaign storage c = campaigns[_id];
        require(block.timestamp < c.deadline, "Campaign ended");
        require(msg.value > 0, "Must donate more than 0");

        c.raised += msg.value;
        donations[_id][msg.sender] += msg.value;

        emit DonationReceived(_id, msg.sender, msg.value);
    }

    /// @notice Withdraw funds if goal reached
    function withdraw(uint256 _id) public {
        Campaign storage c = campaigns[_id];
        require(msg.sender == c.creator, "Only creator can withdraw");
        require(block.timestamp >= c.deadline, "Campaign not ended yet");
        require(c.raised >= c.goal, "Goal not reached");
        require(!c.withdrawn, "Already withdrawn");

        c.withdrawn = true;
        payable(c.creator).transfer(c.raised);

        emit FundsWithdrawn(_id, c.raised);
    }
}
