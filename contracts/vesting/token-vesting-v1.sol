pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";

contract TokenVesting is Ownable {
  using SafeMath for uint;

  ERC20 public token;
  address public receiver;
  uint256 public startTime;
  uint256 public cliff;
  uint256 public totalPeriods;
  uint256 public timePerPeriod;
  uint256 public totalTokens;
  uint256 public tokensClaimed;

  event VestingFunded(uint256 totalTokens);
  event TokensClaimed(uint256 tokensClaimed);
  event VestingKilled();

  /**
  *@dev contructor
  *@param _token address of erc20 token
  *@param _receiver address entitle to claim tokens
  *@param _startTime moment when counting time starts
  *@param _cliff delay from _startTime after which vesting starts
  *@param _totalPeriods total amount of vesting periods
  *@param _timePerPeriod time in seconds for every vesting period
  */
  constructor(
    address _token,
    address _receiver,
    uint256 _startTime,
    uint256 _cliff,
    uint256 _totalPeriods,
    uint256 _timePerPeriod
  ) public {
    token = ERC20(_token);
    receiver = _receiver;
    startTime = _startTime;
    cliff = _cliff;
    totalPeriods = _totalPeriods;
    timePerPeriod = _timePerPeriod;
  }

  /*
  *@dev function responsible for supplying tokens that will be vested
  *@param _totalTokens amount of tokens that will be supplied to this contract
  */
  function fundVesting(uint256 _totalTokens) public onlyOwner {
    require(totalTokens == 0, "Vesting already funded");
    require(token.allowance(owner, address(this)) == _totalTokens);
    totalTokens = _totalTokens;
    token.transferFrom(owner, address(this), totalTokens);
    emit VestingFunded(_totalTokens);
  }

  /*
  *@dev Function that allows the contract owner to change tokens receiver
  *@param newReceiver the new receiver address
  */
  function changeReceiver(address newReceiver) public onlyOwner {
    require(newReceiver != address(0));
    receiver = newReceiver;
  }

  /**
  *@dev function that allows receiver to claim tokens, can be called only by
    receiver
  */
  function claimTokens() public {

    require(totalTokens > 0, "Vesting has not been funded yet");
    require(msg.sender == receiver, "Only receiver can claim tokens");
    require(now > startTime.add(cliff), "Vesting hasnt started yet");

    uint256 timePassed = now.sub(startTime.add(cliff));
    uint256 tokensToClaim = totalTokens
      .div(totalPeriods)
      .mul(timePassed.div(timePerPeriod))
      .sub(tokensClaimed);

    token.transfer(receiver, tokensToClaim);
    tokensClaimed = tokensClaimed.add(tokensToClaim);

    emit TokensClaimed(tokensToClaim);

  }

  /**
  *@dev function that allows cancel vesting, can be called only by the owner
  */
  function killVesting() public onlyOwner {
    token.transfer(owner, totalTokens.sub(tokensClaimed));
    tokensClaimed = totalTokens;
    emit VestingKilled();
  }

}
