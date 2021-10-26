// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../interfaces/ICoin.sol";

contract StableCoinToken is ERC20, ICoin, Ownable {

    mapping (address => uint256) private _balances;

    constructor() public ERC20("AUD Stablecoin", "AUDC") {}

    function mint(address account, uint256 amount) external override returns(bool){
        require(account != address(0), "ERC20: mint to the zero address");
        _beforeTokenTransfer(address(0), account, amount);
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
        _afterTokenTransfer(address(0), account, amount);
    }
    function burn(address account, uint256 amount) external override returns(bool){
        require(account != address(0), "ERC20: burn from the zero address");
        _beforeTokenTransfer(account, address(0), amount);
        _balances[account] -= amount;
        emit Transfer(account, address(0), amount);
        _afterTokenTransfer(account, address(0), amount);
    }
}