// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GameToken is ERC20 {
    event Mint(address indexed to, uint256 amount);

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        uint256 initialSupply = 1000000 * 10 ** 18;
        _mint(msg.sender, initialSupply);
        emit Mint(msg.sender, initialSupply);
    }
}
