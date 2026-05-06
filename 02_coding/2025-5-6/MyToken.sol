// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// 直接从 OpenZeppelin 官方库引入标准 ERC20 实现
// Remix 支持直接从 GitHub 的 npm 路径导入
import "@openzeppelin/contracts@5.0.2/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@5.0.2/access/Ownable.sol";

contract Mytoken is ERC20,Ownable{
    constructor() ERC20("BoWei Token", "BVB") Ownable(msg.sender) {
        _mint(msg.sender,1_000_000 * 10 ** decimals());
    }
    function mint(address to, uint256 amount) external onlyOwner{
        _mint(to,amount);
    }
}