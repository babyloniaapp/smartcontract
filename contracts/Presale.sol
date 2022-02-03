// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";


contract Presale is Ownable, ReentrancyGuard {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    event Deposited(
        address indexed user,
        uint256 amount
    );

    event presaleEnabledUpdated(bool enabled);

    IERC20 public busd;
    IERC20 public baby;
    mapping(address => uint256) public deposits;

    address[] public investors;

    address public masterWallet;
    uint256 public totalDepositedBusdBalance;

    uint256 public depositRate = 200; // 1 busd = 100 * baby
    uint256 public totalPresalAmount = 88888888 * 10 ** 18;
    uint256 public currentPresaleAmount = 0;
    uint256 public startTime;
    uint256 public endTime;

    bool public presaleEnabled = true;

    constructor(IERC20 _busd, IERC20 _baby, address _masterWallet) public {
        require(address(_busd) != address(0), "BUSD address should not be zero address");
        require(address(_baby) != address(0), "BABY address should not be zero address");
        require(_masterWallet != address(0), "master wallet address should not be zero address");
        busd = _busd;
        baby = _baby;
        masterWallet = _masterWallet;

        totalDepositedBusdBalance = 0;
        startTime = block.timestamp;
        endTime = block.timestamp + (28 * 1 days);
   }

    function depositedUser() public view returns (uint256) {
        return investors.length;
    }
    function updatePresaleRate(uint256 rate) public onlyOwner{
        require(rate > 0, "UpdateSwapRate: Rate is less than Zero");
        depositRate = rate;
    }

    function setPresaleEnabled(bool _enabled) public onlyOwner{
        presaleEnabled = _enabled;
        emit presaleEnabledUpdated(_enabled);
    }

    function DepositBusd(uint256 _amount) public nonReentrant {
        require(_amount > 0, "BUSD Amount is less than zero");
        require(presaleEnabled == true, "Presale: Presale is not available");
        require(block.timestamp > startTime && block.timestamp < endTime, "Presale period already passed");
        uint256 babyTokenAmount = _amount.mul(depositRate);
        require((baby.balanceOf(msg.sender) + babyTokenAmount) <= 1000000 * 10 ** 18, "Cannot hold more than 10000 $baby in your wallet");

        busd.safeTransferFrom(msg.sender, masterWallet, _amount);
        baby.safeTransferFrom(masterWallet, msg.sender, babyTokenAmount);

        totalDepositedBusdBalance = totalDepositedBusdBalance + _amount;
        currentPresaleAmount += babyTokenAmount;
        updateDepositRate();
        if(deposits[msg.sender] == 0) {
            investors.push(msg.sender);
        }
        deposits[msg.sender] = deposits[msg.sender] + _amount;
        emit Deposited(msg.sender, _amount);
    }

    function updateDepositRate() public{
        depositRate = 100 + (totalPresalAmount - currentPresaleAmount).mul(100).div(totalPresalAmount);
    }

    function updatebabyToken(IERC20 _baby) public onlyOwner{
        require(address(_baby) != address(0), "OldVgdToken address should not be zero address");
        baby = _baby;
    }

    function updateMasterWalletAddress(address _newWalletAddr) public onlyOwner{
        require(address(_newWalletAddr) != address(0), "Wallet address should not be zero address");
        masterWallet = _newWalletAddr;
    }
}