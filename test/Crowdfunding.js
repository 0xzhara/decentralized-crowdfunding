const { expect } = require("chai");

describe("Crowdfunding", function () {
  let Crowdfunding, crowdfunding, owner, donor;

  beforeEach(async function () {
    [owner, donor] = await ethers.getSigners();
    Crowdfunding = await ethers.getContractFactory("Crowdfunding");
    crowdfunding = await Crowdfunding.deploy();
    await crowdfunding.deployed();
  });

  it("should create a campaign", async function () {
    await crowdfunding.createCampaign("Build Web3 App", ethers.utils.parseEther("1"), 60);
    const campaign = await crowdfunding.campaigns(1);
    expect(campaign.title).to.equal("Build Web3 App");
  });

  it("should accept donations", async function () {
    await crowdfunding.createCampaign("Test Campaign", ethers.utils.parseEther("1"), 60);
    await crowdfunding.connect(donor).donate(1, { value: ethers.utils.parseEther("0.5") });
    const campaign = await crowdfunding.campaigns(1);
    expect(campaign.raised).to.equal(ethers.utils.parseEther("0.5"));
  });

  it("should allow withdrawal after goal is reached", async function () {
    await crowdfunding.createCampaign("Big Project", ethers.utils.parseEther("1"), 1);
    await crowdfunding.connect(donor).donate(1, { value: ethers.utils.parseEther("1") });

    // increase time
    await ethers.provider.send("evm_increaseTime", [2]);
    await ethers.provider.send("evm_mine");

    await crowdfunding.withdraw(1);
    const campaign = await crowdfunding.campaigns(1);
    expect(campaign.withdrawn).to.equal(true);
  });
});
