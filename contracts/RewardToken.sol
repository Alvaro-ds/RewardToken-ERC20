// SPDX-License-Identifier: LGPL-3.0-only

pragma solidity 0.8.24;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract RewardToken is ERC20{

    address public owner;
    uint256 public feePercent = 2;


    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_){
        owner = msg.sender;
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


    function distributeRewards(address[] calldata holders_) external {

        require(msg.sender == owner, "Not owner");

        uint256 contractBalance = balanceOf(address(this));
        require(contractBalance > 0, "No balance");

        uint256 holdersTokens = 0;

        for (uint256 i = 0; i < holders_.length; i++) {
            holdersTokens += balanceOf(holders_[i]);
        }

        require(holdersTokens > 0, "No holders");

        for (uint256 i = 0; i < holders_.length; i++) {
            uint256 holderBalance = balanceOf(holders_[i]);
            
            if (holderBalance > 0){
                uint256 reward = (contractBalance * holderBalance) / holdersTokens;

                super._update(address(this), holders_[i], reward);
            }
        }
    }


    function setFee(uint256 newFeePercent_) external {

        require(msg.sender == owner, "Not owner");
        require(newFeePercent_ <= 10, "Too high fee");

        feePercent = newFeePercent_;
    }

}