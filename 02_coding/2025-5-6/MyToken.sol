// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts@5.0.2/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@5.0.2/access/Ownable.sol";

contract Mytoken is ERC20,Ownable{
    constructor() ERC20("BoWei Token", "BVB") Ownable(msg.sender) {
        _mint(msg.sender,1_000_000 * 10 ** decimals());//mint 100w tokens to owner --init
    }
    function mint(address to, uint256 amount) external onlyOwner{//only owner can call this mint func
        _mint(to,amount);
    }
}