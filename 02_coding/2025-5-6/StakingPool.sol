// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts@5.0.2/token/ERC20/IERC20.sol";
contract StakingPool{
    IERC20 public stakingToken;
    IERC20 public rewardToken;
    uint256 public rewardRatePerSecond;

    struct StakeInfo {
        uint256 amount;
        uint256 lastUpdateTime;
        uint256 pendingReward;
    }
}