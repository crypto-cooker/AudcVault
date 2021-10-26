// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IVault.sol";
import "hardhat/console.sol";
import "./Coin.sol";

contract Vault is IVault {
    
    IERC20 public stableCoin;

    // There is one vault per collateral type ex: User => ETH => Vault
    mapping(address => mapping(string => Vault)) private collateralToVault;
    // Each Collateral has is own price of Stable coin ex : ETH price is 4000, USDT price is 1;
    mapping(string => uint256) private collateralPrice;
    // Current Selected Collateral ex : ETH
    string public selectedCollateral = "ETH"; 

    public uint256 ethPrice = 4000;
    
    constructor(address stableCoinAddr){
        stableCoin = new IERC20(stableCoinAddr);
    }
    
    function deposit(uint256 amountToDeposit) public override {
        require(amountToDeposit>0, "Deposit amount should be bigger than zero!");
        collateralToVault[msg.sender][selectedCollateral].collateralAmount += amountToDeposit;
        uint256 amountMinted = estimateTokenAmount(amountToDeposit);

        // user who deposit will mint stable coin of collateral ratio 100% against collateral
        collateralToVault[msg.sender][selectedCollateral].debtAmount += amountMinted;  
        stableCoin.mint(msg.sender, amountMinted);
        
        emit Deposit(amountToDeposit, amountMinted);
    }

    function withdraw(uint256 repaymentAmount) public override {
        require(repaymentAmount>0, "Withdraw amount should be bigger than zero!");
        uint256 collateralWithdrawn = estimateCollateralAmount(repaymentAmount);
        collateralToVault[msg.sender][selectedCollateral].collateralAmount += collateralWithdrawn;

        collateralToVault[msg.sender][selectedCollateral].debtAmount -= repaymentAmount;
        stableCoin.burn(msg.sender, repaymentAmount);

        emit Withdraw(collateralWithdrawn, repaymentAmount);
    }

    function getVault(address userAddress) public view override returns(Vault memory vault) {
        return collateralToVault[userAddress][selectedCollateral];
    }
    
    function estimateCollateralAmount(uint256 repaymentAmount) external view override returns(uint256 collateralAmount) {
        return repaymentAmount / collateralPrice[selectedCollateral];
    }

    function estimateTokenAmount(uint256 depositAmount) external view override returns(uint256 tokenAmount) {
        return depositAmount * collateralPrice[selectedCollateral];
    }
}
