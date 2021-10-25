// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../interfaces/ICoin.sol";

contract StableCoinToken is ERC20, ICoin, Ownable {
    constructor() public ERC20("AUD Stablecoin", "AUDC") {}

    function mint(address account, uint256 amount) external override returns(bool){}
    function burn(address account, uint256 amount) external override returns(bool){}
    
}