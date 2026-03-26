# RewardToken (ERC-20 with Fee-Based Reward Distribution)

## Overview

**RewardToken** is an ERC-20 compliant smart contract that introduces a simple and transparent reward distribution mechanism based on transaction fees.

Each token transfer applies a configurable fee that is accumulated within the contract. These collected tokens can later be distributed proportionally among holders by the contract owner.

This project is designed as a learning-oriented implementation that demonstrates how to extend standard ERC-20 functionality using OpenZeppelin and internal hooks.

---

## Key Features

### Fee on Transfers

* Every standard token transfer applies a percentage-based fee.
* The fee is automatically redirected to the contract itself.
* The recipient receives the net amount after fee deduction.

### Reward Pool Accumulation

* All collected fees are stored in the contract balance.
* This balance acts as a reward pool for token holders.

### Manual Reward Distribution

* The owner can distribute accumulated rewards to a list of holders.
* Distribution is proportional to each holder’s token balance.

### Owner-Controlled Parameters

* Ability to update the fee percentage (with a capped limit).
* Restricted access to reward distribution and configuration functions.

---

## Contract Architecture

The contract extends OpenZeppelin’s `ERC20` implementation and overrides the internal `_update` function to introduce custom transfer behavior.

### Core Components

* **ERC-20 Standard (OpenZeppelin)**
* **Custom Fee Logic via `_update` override**
* **Reward Distribution Function**
* **Owner Access Control**

---

## How It Works

### 1. Transfer with Fee

When a user transfers tokens:

* A percentage (`feePercent`) is calculated from the transfer amount.
* The fee is sent to the contract.
* The remaining tokens are sent to the recipient.

**Example:**

* Transfer: 100 tokens
* Fee (2%): 2 tokens → contract
* Net: 98 tokens → recipient

---

### 2. Reward Accumulation

* All fees are stored in the contract’s own balance.
* This creates a pool of tokens available for redistribution.

---

### 3. Reward Distribution

The owner can call:

```
distributeRewards(address[] holders)
```

Process:

1. The contract balance is captured (snapshot).
2. Total tokens held by provided addresses are calculated.
3. Each holder receives a proportional share:

[
reward = \frac{contractBalance \times holderBalance}{totalHeld}
]

4. Tokens are transferred from the contract to each holder.

---

## Functions

### `constructor(string name_, string symbol_)`

* Initializes the token.
* Mints initial supply to the deployer.

---

### `_update(address from, address to, uint256 value)`

* Overrides OpenZeppelin internal transfer logic.
* Applies fee on standard transfers.
* Handles minting and burning without fees.

---

### `distributeRewards(address[] holders_)`

* Distributes accumulated fees to holders.
* Only callable by the owner.

---

### `setFee(uint256 newFeePercent_)`

* Updates the transaction fee.
* Maximum allowed: 10%.

---

## Design Decisions

### Use of `_update`

The contract leverages OpenZeppelin v5’s `_update` hook, which centralizes all token state changes. This ensures:

* Compatibility with ERC-20 standard
* Consistent behavior across `transfer` and `transferFrom`
* Clean integration of custom logic

---

### Manual Distribution Model

Rewards are distributed manually to avoid:

* High gas costs from automatic distribution
* Complexity of reflection mechanisms

---

## Limitations

### Gas Scalability

* Distribution relies on loops over holder arrays.
* Large lists may exceed gas limits.

### Off-Chain Dependency

* The contract does not track holders internally.
* The owner must supply holder addresses manually.

### Precision Loss

* Integer division may result in leftover tokens (“dust”) in the contract.

### Timing Exploits

* Users can acquire tokens shortly before distribution to receive rewards.

---

## Security Considerations

* Only the owner can:

  * Distribute rewards
  * Modify the fee
* Fee is capped to prevent abusive configurations.
* Minting occurs only at deployment.

---

## Possible Improvements

* Exclude specific addresses from fees or rewards
* Add events for transparency (e.g., `RewardsDistributed`)
* Introduce minimum balance threshold for rewards
* Implement cooldown between distributions
* Move toward a reflection-based model (no loops)

---

## Use Cases

* Educational demonstration of ERC-20 extensibility
* Prototype for fee-based tokenomics
* Foundation for DeFi-style reward systems

---

## Conclusion

RewardToken is a clean and modular extension of the ERC-20 standard that demonstrates how to:

* Modify token transfer behavior
* Accumulate and redistribute value
* Implement controlled economic logic

It provides a solid foundation for understanding more advanced token designs used in decentralized finance.

---
