// SPDX-License-Identifier: LGPL-3.0-only

pragma solidity 0.8.24;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract RewardToken is ERC20{

    address public owner;
    uint256 public feePercent = 2;
    uint256 public rewardAmount;

    mapping(address => bool) public whiteListed;
    mapping(address => bool) public claimed;

    constructor(string memory name_, string memory symbol_, uint256 rewardAmount_) ERC20(name_, symbol_){
        owner = msg.sender;
        rewardAmount = rewardAmount_;
        _mint(msg.sender, 1000 * 1e18);
    }


    // Keep fees at contract and send the net amount to a wallet
    function _update(address from, address to, uint256 value) internal override {
        
        if (from != address(0) && to != address(0)) {
            uint256 feeCorresponding = (value * feePercent) / 100;
            uint256 netAmount = value - feeCorresponding;

            super._update(from, address(this), feeCorresponding);

            super._update(from, to, netAmount);
        
        } else {
            super._update(from, to, value);
        }

    }

    // Owner adds users to the white list
    function addToWhitelist(address user_) external{

        require(msg.sender == owner, "Not owner");
        whiteListed[user_] = true;
    }

    // User claims reward thanks to pull pattern
    function claim() external {

        require(whiteListed[msg.sender], "Not in the white list");
        require(!claimed[msg.sender], "Already claimed");

        require(balanceOf(address(this)) >= rewardAmount, "Insuficient amount at pool");

        claimed[msg.sender] = true;

        super._update(address(this), msg.sender, rewardAmount);
    }

    // Owner can set a new fee percent
    function setFee(uint256 newFeePercent_) external {

        require(msg.sender == owner, "Not owner");
        require(newFeePercent_ <= 10, "Too high fee");

        feePercent = newFeePercent_;
    }

    // Owner can set a new reward amount
    function setRewardAmount(uint256 newRewardAmount_) external {
        require(msg.sender == owner, "Not owner");

        rewardAmount = newRewardAmount_;
    }

}
