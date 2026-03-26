# RewardToken (ERC-20 with Fee-Based Claim System)

## Overview

**RewardToken** is an ERC-20 compliant smart contract that implements a reward mechanism based on transaction fees using a **pull-based claim model with whitelist control**.

Each token transfer applies a configurable fee that is accumulated within the contract. Instead of distributing rewards in batch, eligible users are added to a whitelist and can individually claim a fixed reward from the contract.

This project demonstrates how to extend the ERC-20 standard using OpenZeppelin while applying secure and scalable design patterns such as **pull over push**.

---

## Key Features

### Fee on Transfers

* Every standard token transfer applies a percentage-based fee.
* The fee is automatically redirected to the contract.
* The recipient receives the net amount after fee deduction.

---

### Reward Pool Accumulation

* All collected fees are stored in the contract balance.
* This balance acts as a reward pool from which users can claim rewards.

---

### Pull-Based Reward Claim

* Users do not receive rewards automatically.
* Instead, they must call a `claim()` function.
* Each user can claim only once.

---

### Whitelist Control

* Only addresses explicitly approved by the owner can claim rewards.
* This ensures controlled and secure distribution.

---

### Owner-Controlled Parameters

* Ability to update the fee percentage (capped).
* Ability to update the reward amount.
* Ability to manage the whitelist.

---

## Contract Architecture

The contract extends OpenZeppelin’s `ERC20` implementation and overrides the internal `_update` function to introduce custom transfer behavior.

### Core Components

* **ERC-20 Standard (OpenZeppelin)**
* **Custom Fee Logic via `_update` override**
* **Whitelist-based Claim System**
* **Owner Access Control**

---

## How It Works

### 1. Transfer with Fee

When a user transfers tokens:

* A percentage (`feePercent`) is taken as a fee.
* The fee is sent to the contract.
* The remaining tokens are sent to the recipient.

**Example:**

* Transfer: 100 tokens
* Fee (2%): 2 tokens → contract
* Net: 98 tokens → recipient

---

### 2. Reward Pool Accumulation

* Fees collected from transfers accumulate in the contract.
* This pool is used to fund user rewards.

---

### 3. Whitelisting

The owner adds eligible users:

```
addToWhitelist(address user)
```

Only whitelisted users can claim rewards.

---

### 4. Claim Process (Pull Pattern)

Users claim rewards manually:

```
claim()
```

Requirements:

* User must be whitelisted
* User must not have claimed before
* Contract must have enough tokens in the pool

If all conditions are met:

* The user receives `rewardAmount`
* The claim is marked as completed

---

## Functions

### `constructor(string name_, string symbol_, uint256 rewardAmount_)`

* Initializes the token.
* Sets the reward amount.
* Mints initial supply to the deployer.

---

### `_update(address from, address to, uint256 value)`

* Overrides OpenZeppelin internal transfer logic.
* Applies fee on standard transfers.
* Excludes minting and burning from fees.

---

### `addToWhitelist(address user_)`

* Adds a user to the whitelist.
* Only callable by the owner.

---

### `claim()`

* Allows a whitelisted user to claim their reward.
* Uses pull pattern (user-initiated transaction).
* Prevents double claims.

---

### `setFee(uint256 newFeePercent_)`

* Updates the transaction fee.
* Maximum allowed: 10%.

---

### `setRewardAmount(uint256 newRewardAmount_)`

* Updates the reward amount.
* Only callable by the owner.

---

## Design Decisions

### Use of `_update`

The contract leverages OpenZeppelin v5’s `_update` hook, ensuring:

* Full compatibility with ERC-20
* Consistent behavior across all transfers
* Centralized control of token movement logic

---

### Pull over Push Model

The contract uses a **pull-based reward system** instead of batch distribution:

* Eliminates gas issues from loops
* Prevents denial-of-service scenarios
* Ensures scalability regardless of number of users

---

### Fixed Reward Model

Each user receives a fixed reward (`rewardAmount`) instead of a proportional distribution.

---

## Limitations

### Fixed Reward (Not Proportional)

* Rewards are not based on token holdings.
* All users receive the same amount.

---

### Dependency on Contract Balance

* Claims will fail if the contract does not have enough tokens.
* The reward pool depends entirely on collected fees or manual funding.

---

### Manual Whitelisting

* The owner must explicitly add users.
* No automatic eligibility detection.

---

### No Partial Distribution

* If the pool is insufficient, claims revert.
* No fallback or partial payouts.

---

## Security Considerations

* Only the owner can:

  * Manage whitelist
  * Modify fee
  * Modify reward amount
* Double claim prevention via `claimed` mapping
* Fee is capped to prevent abusive configurations
* Claim requires sufficient contract balance

---

## Possible Improvements

* Batch whitelist addition
* Event emission for transparency (`Claimed`, `Whitelisted`)
* Minimum pool threshold before enabling claims
* Time-based claim windows
* Dynamic reward calculation
* Transition to proportional or staking-based rewards

---

## Use Cases

* Controlled token airdrops
* Incentive campaigns
* Educational demonstration of pull-based reward systems
* Secure alternative to batch token distribution

---

## Conclusion

RewardToken demonstrates how to extend the ERC-20 standard with:

* Custom fee mechanics
* Internal reward accumulation
* Secure and scalable pull-based distribution
* Whitelist-controlled access

It provides a solid foundation for understanding real-world smart contract design patterns used in modern blockchain systems.

---
