# 💰 Decentralized Crowdfunding

A decentralized crowdfunding platform built with Solidity + Hardhat.  
Users can create campaigns, donate ETH, and withdraw funds if the funding goal is reached.

## ✨ Features
- Create crowdfunding campaigns with goals and deadlines
- Donate ETH to support campaigns
- Campaign creator can withdraw funds if goal is reached
- On-chain event logs for transparency

## 🚀 Getting Started

### 1. Clone repository
```bash
git clone https://github.com/<username>/decentralized-crowdfunding.git
cd decentralized-crowdfunding

npm install

npx hardhat test

ALCHEMY_API_URL=https://eth-sepolia.g.alchemy.com/v2/<API_KEY>
PRIVATE_KEY=0xabc123...

npx hardhat run scripts/deploy.js --network sepolia
