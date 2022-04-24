// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./IERC20.sol";
import "./SafeERC20.sol";


contract Presale is Ownable, ReentrancyGuard {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    event Deposited(
        address indexed user,
        uint256 amount
    );

    event presaleEnabledUpdated(bool enabled);

    IERC20 public busd;
    IERC20 public usdt;
    IERC20 public usdc;
    IERC20 public baby;
    mapping(address => uint256) public deposits;

    address[] public investors;

    address public masterWallet;
    uint256 public totalDepositedBusdBalance;

    uint256 public depositRate = 100; // 1 busd = 100 * baby
    uint256 public startTime;
    uint256 public endTime;

    bool public presaleEnabled = true;

    constructor(IERC20 _busd, IERC20 _usdt, IERC20 _usdc, IERC20 _baby, address _masterWallet) {
        require(address(_busd) != address(0), "BUSD address should not be zero address");
        require(address(_usdt) != address(0), "BUSD address should not be zero address");
        require(address(_usdc) != address(0), "BUSD address should not be zero address");
        require(address(_baby) != address(0), "BABY address should not be zero address");
        require(_masterWallet != address(0), "Master wallet address should not be zero address");
        busd = _busd;
        usdt = _usdt;
        usdc = _usdc;
        baby = _baby;
        masterWallet = _masterWallet;

        totalDepositedBusdBalance = 0;
        startTime = block.timestamp;
        endTime = block.timestamp + (30 * 1 days);
   }

    function depositedUser() external view returns (uint256) {
        return investors.length;
    }
    function updatePresaleRate(uint256 rate) external onlyOwner{
        require(rate > 0, "UpdateSwapRate: Rate is less than Zero");
        depositRate = rate;
    }

    function setPresaleEnabled(bool _enabled) external onlyOwner{
        presaleEnabled = _enabled;
        emit presaleEnabledUpdated(_enabled);
    }

    function DepositBusd(uint256 _amount, uint256 _type) external nonReentrant {
        require(_amount > 0, "BUSD Amount is less than zero");
        require(presaleEnabled == true, "Presale: Presale is not available");
        require(block.timestamp > startTime && block.timestamp < endTime, "Presale period already passed");
        require(_type >= 0 && _type <= 2, "Type should be in range of 0 to 2");

        uint256 babyTokenAmount;
        uint256 _tokenDecimals;

        if (_type == 0) {
            _tokenDecimals = busd.decimals();
            babyTokenAmount = _amount.mul(depositRate).mul(10 ** baby.decimals()).div(10 ** _tokenDecimals);
            require((baby.balanceOf(msg.sender) + babyTokenAmount) <= 10000 * 10 ** 18, "Cannot hold more than 10000 $baby in your wallet");
            busd.safeTransferFrom(msg.sender, masterWallet, _amount);
        }
        else if (_type == 1) {
            _tokenDecimals = usdt.decimals();
            babyTokenAmount = _amount.mul(depositRate).mul(10 ** baby.decimals()).div(10 ** _tokenDecimals);
            require((baby.balanceOf(msg.sender) + babyTokenAmount) <= 10000 * 10 ** 18, "Cannot hold more than 10000 $baby in your wallet");
            usdt.safeTransferFrom(msg.sender, masterWallet, _amount);
        }
        else {
            _tokenDecimals = usdc.decimals();
            babyTokenAmount = _amount.mul(depositRate).mul(10 ** baby.decimals()).div(10 ** _tokenDecimals);
            require((baby.balanceOf(msg.sender) + babyTokenAmount) <= 10000 * 10 ** 18, "Cannot hold more than 10000 $baby in your wallet");
            usdc.safeTransferFrom(msg.sender, masterWallet, _amount);
        }

        baby.safeTransferFrom(masterWallet, msg.sender, babyTokenAmount);

        totalDepositedBusdBalance = totalDepositedBusdBalance + _amount.div(10 ** _tokenDecimals);
        if(deposits[msg.sender] == 0) {
            investors.push(msg.sender);
        }
        deposits[msg.sender] = deposits[msg.sender] + _amount;
        emit Deposited(msg.sender, _amount);
    }

    function updatebabyToken(IERC20 _baby) external onlyOwner{
        require(address(_baby) != address(0), "OldVgdToken address should not be zero address");
        baby = _baby;
    }

    function updateMasterWalletAddress(address _newWalletAddr) external onlyOwner{
        require(address(_newWalletAddr) != address(0), "Wallet address should not be zero address");
        masterWallet = _newWalletAddr;
    }
}