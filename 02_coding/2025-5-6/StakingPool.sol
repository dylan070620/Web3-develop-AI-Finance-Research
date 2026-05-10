// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts@5.0.2/token/ERC20/IERC20.sol";
contract StakingPool{
    IERC20 public stakingToken;
    IERC20 public rewardToken;  
    uint256 public rewardRatePerSecond; // interest rate

    struct StakeInfo {
        uint256 amount;
        uint256 lastUpdateTime;
        uint256 pendingReward;
    }
    mapping (address => StakeInfo) public stakes;

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event RewardClaimed(address indexed user, uint256 amount);
    
    constructor(address _stakingToken,address _rewardToken,uint256 _rewardRatePerSecond){
        stakingToken = IERC20(_stakingToken);
        rewardToken = IERC20(_rewardToken);
        rewardRatePerSecond = _rewardRatePerSecond;

    }

    function _updateReward(address user) internal {
        StakeInfo storage s = stakes[user];
        if(s.amount>0){
            uint256 timeElapsed = block.timestamp - s.lastUpdateTime;
            uint256 newReward = s.amount * rewardRatePerSecond * timeElapsed / 1e18;
            s.pendingReward += newReward;
        }
        s.lastUpdateTime = block.timestamp;
    }
    
   function _stake(uint256 amount) external {
        require(amount>0,"amount must be >0 ");
        _updateReward(msg.sender);
        bool txfrom = stakingToken.transferFrom(msg.sender,address(this),amount);
        require(txfrom,"TX fail");
        stakes[msg.sender].amount += amount;
        emit Staked(msg.sender,amount);
   } 

   function _unstake(uint256 amount) external{
       require(amount > 0, "amount must be > 0");
       require(amount <= stakes[msg.sender].amount, "insufficient balance");
       _updateReward(msg.sender);
       stakes[msg.sender].amount -= amount;
       bool txto = stakingToken.transfer(msg.sender,amount);
       require(txto,"TX fail");
       emit Unstaked(msg.sender,amount);
   }

   function _claimReward() external {
       _updateReward(msg.sender);
       uint256 reward = stakes[msg.sender].pendingReward;
       require(reward > 0, "no reward available");
       stakes[msg.sender].pendingReward = 0;
       bool tx = rewardToken.transfer(msg.sender, reward);
       require(tx, "TX fail");
       emit RewardClaimed(msg.sender, reward);//
   }
}