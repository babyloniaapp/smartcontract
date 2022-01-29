/**
 *Submitted for verification at BscScan.com on 2021-12-21
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/*

┌┐░░░░┌┐░░░░░┌┐░░░░░░░░░░░░░░░░░░░░░░░░░
││░░░░││░░░░░││░░░░░░░░░░░░░░░░░░░░░░░░░
│└─┬──┤└─┬┐░┌┤│┌──┬─┐┌┬──┐┌──┬──┬──┐░░░░
│┌┐│┌┐│┌┐││░││││┌┐│┌┐┼┤┌┐││┌┐│┌┐│┌┐│░░░░
│└┘│┌┐│└┘│└─┘│└┤└┘│││││┌┐├┤┌┐│└┘│└┘│░░░░
└──┴┘└┴──┴─┐┌┴─┴──┴┘└┴┴┘└┴┴┘└┤┌─┤┌─┘░░░░
░░░░░░░░░┌─┘│░░░░░░░░░░░░░░░░││░││░░░░░░
░░░░░░░░░└──┘░░░░░░░░░░░░░░░░└┘░└┘░░░░░░

Website: https://www.babylonia.app
Documents: https://docs.babylonia.app
Telegram: https://t.me/babyloniageneralchat
Twitter: https://twitter.com/AppBabylonia

*/

import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BABYV2Token is Context, IERC20, Ownable {
  using SafeMath for uint256;

  mapping(address => uint256) private _balances;

  mapping(address => mapping(address => uint256)) private _allowances;

  uint256 private _totalSupply;
  uint8 public _decimals;
  string public _symbol;
  string public _name;

  constructor() {
    _name = 'Babylonia Token';
    _symbol = 'BABY';
    _decimals = 10;
    _totalSupply = 888888888 * 10**10; // 888m
    _balances[msg.sender] = _totalSupply;

    emit Transfer(address(0), msg.sender, _totalSupply);
  }

  /**
   * @dev Returns the bep token owner.
   */
  function getOwner() external view returns (address) {
    return owner();
  }

  /**
   * @dev Returns the token decimals.
   */
  function decimals() external view returns (uint8) {
    return _decimals;
  }

  /**
   * @dev Returns the token symbol.
   */
  function symbol() external view returns (string memory) {
    return _symbol;
  }

  /**
   * @dev Returns the token name.
   */
  function name() external view returns (string memory) {
    return _name;
  }

  /**
   * @dev See {BEP20-totalSupply}.
   */
  function totalSupply() external view virtual override returns (uint256) {
    return _totalSupply;
  }

  /**
   * @dev See {BEP20-balanceOf}.
   */
  function balanceOf(address account)
    external
    view
    virtual
    override
    returns (uint256)
  {
    return _balances[account];
  }

  /**
   * @dev See {BEP20-transfer}.
   *
   * Requirements:
   *
   * - `recipient` cannot be the zero address.
   * - the caller must have a balance of at least `amount`.
   */
  function transfer(address recipient, uint256 amount)
    external
    override
    returns (bool)
  {
    _transfer(_msgSender(), recipient, amount);
    return true;
  }

  /**
   * @dev See {BEP20-allowance}.
   */
  function allowance(address owner, address spender)
    external
    view
    override
    returns (uint256)
  {
    return _allowances[owner][spender];
  }

  /**
   * @dev See {BEP20-approve}.
   *
   * Requirements:
   *
   * - `spender` cannot be the zero address.
   */
  function approve(address spender, uint256 amount)
    external
    override
    returns (bool)
  {
    _approve(_msgSender(), spender, amount);
    return true;
  }

  /**
   * @dev See {BEP20-transferFrom}.
   *
   * Emits an {Approval} event indicating the updated allowance. This is not
   * required by the EIP. See the note at the beginning of {BEP20};
   *
   * Requirements:
   * - `sender` and `recipient` cannot be the zero address.
   * - `sender` must have a balance of at least `amount`.
   * - the caller must have allowance for `sender`'s tokens of at least
   * `amount`.
   */
  function transferFrom(
    address sender,
    address recipient,
    uint256 amount
  ) external override returns (bool) {
    _transfer(sender, recipient, amount);
    _approve(
      sender,
      _msgSender(),
      _allowances[sender][_msgSender()].sub(
        amount,
        'BEP20: transfer amount exceeds allowance'
      )
    );
    return true;
  }

  /**
   * @dev Atomically increases the allowance granted to `spender` by the caller.
   *
   * This is an alternative to {approve} that can be used as a mitigation for
   * problems described in {BEP20-approve}.
   *
   * Emits an {Approval} event indicating the updated allowance.
   *
   * Requirements:
   *
   * - `spender` cannot be the zero address.
   */
  function increaseAllowance(address spender, uint256 addedValue)
    public
    returns (bool)
  {
    _approve(
      _msgSender(),
      spender,
      _allowances[_msgSender()][spender].add(addedValue)
    );
    return true;
  }

  /**
   * @dev Atomically decreases the allowance granted to `spender` by the caller.
   *
   * This is an alternative to {approve} that can be used as a mitigation for
   * problems described in {BEP20-approve}.
   *
   * Emits an {Approval} event indicating the updated allowance.
   *
   * Requirements:
   *
   * - `spender` cannot be the zero address.
   * - `spender` must have allowance for the caller of at least
   * `subtractedValue`.
   */
  function decreaseAllowance(address spender, uint256 subtractedValue)
    public
    returns (bool)
  {
    _approve(
      _msgSender(),
      spender,
      _allowances[_msgSender()][spender].sub(
        subtractedValue,
        'BEP20: decreased allowance below zero'
      )
    );
    return true;
  }

  /**
   * @dev Destroys `amount` tokens from the caller.
   *
   * See {BEP20-_burn}.
   */
  function burn(uint256 amount) public virtual {
    _burn(_msgSender(), amount);
  }

  /**
   * @dev Destroys `amount` tokens from `account`, deducting from the caller's
   * allowance.
   *
   * See {BEP20-_burn} and {BEP20-allowance}.
   *
   * Requirements:
   *
   * - the caller must have allowance for ``accounts``'s tokens of at least
   * `amount`.
   */
  function burnFrom(address account, uint256 amount) public virtual {
    uint256 decreasedAllowance =
      _allowances[account][_msgSender()].sub(
        amount,
        'BEP20: burn amount exceeds allowance'
      );

    _approve(account, _msgSender(), decreasedAllowance);
    _burn(account, amount);
  }

  /**
   * @dev Moves tokens `amount` from `sender` to `recipient`.
   *
   * This is internal function is equivalent to {transfer}, and can be used to
   * e.g. implement automatic token fees, slashing mechanisms, etc.
   *
   * Emits a {Transfer} event.
   *
   * Requirements:
   *
   * - `sender` cannot be the zero address.
   * - `recipient` cannot be the zero address.
   * - `sender` must have a balance of at least `amount`.
   */
  function _transfer(
    address sender,
    address recipient,
    uint256 amount
  ) internal {
    require(sender != address(0), 'BEP20: transfer from the zero address');
    require(recipient != address(0), 'BEP20: transfer to the zero address');

    _balances[sender] = _balances[sender].sub(
      amount,
      'BEP20: transfer amount exceeds balance'
    );
    _balances[recipient] = _balances[recipient].add(amount);
    emit Transfer(sender, recipient, amount);
  }

  /**
   * @dev Destroys `amount` tokens from `account`, reducing the
   * total supply.
   *
   * Emits a {Transfer} event with `to` set to the zero address.
   *
   * Requirements
   *
   * - `account` cannot be the zero address.
   * - `account` must have at least `amount` tokens.
   */
  function _burn(address account, uint256 amount) internal {
    require(account != address(0), 'BEP20: burn from the zero address');

    _balances[account] = _balances[account].sub(
      amount,
      'BEP20: burn amount exceeds balance'
    );
    _totalSupply = _totalSupply.sub(amount);
    emit Transfer(account, address(0), amount);
  }

  /**
   * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
   *
   * This is internal function is equivalent to `approve`, and can be used to
   * e.g. set automatic allowances for certain subsystems, etc.
   *
   * Emits an {Approval} event.
   *
   * Requirements:
   *
   * - `owner` cannot be the zero address.
   * - `spender` cannot be the zero address.
   */
  function _approve(
    address owner,
    address spender,
    uint256 amount
  ) internal {
    require(owner != address(0), 'BEP20: approve from the zero address');
    require(spender != address(0), 'BEP20: approve to the zero address');

    _allowances[owner][spender] = amount;
    emit Approval(owner, spender, amount);
  }
}


/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotFrozen` and `whenFrozen`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
abstract contract Pausable is Context, Ownable {
  /**
   * @dev Emitted when the freeze is triggered by `account`.
   */
  event Frozen(address account);

  /**
   * @dev Emitted when the freeze is lifted by `account`.
   */
  event Unfrozen(address account);

  bool private _frozen;

  /**
   * @dev Initializes the contract in unfrozen state.
   */
  constructor () {
    _frozen = false;
  }

  /**
   * @dev Returns true if the contract is frozen, and false otherwise.
   */
  function frozen() public view returns (bool) {
    return _frozen;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is not frozen.
   *
   * Requirements:
   *
   * - The contract must not be frozen.
   */
  modifier whenNotFrozen() {
    require(!frozen(), "Freezable: frozen");
    _;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is frozen.
   *
   * Requirements:
   *
   * - The contract must be frozen.
   */
  modifier whenFrozen() {
    require(frozen(), "Freezable: frozen");
    _;
  }

  /**
   * @dev Triggers stopped state.
   *
   * Requirements:
   *
   * - The contract must not be frozen.
   */
  function _freeze() internal whenNotFrozen {
    _frozen = true;
    emit Frozen(_msgSender());
  }

  /**
   * @dev Returns to normal state.
   *
   * Requirements:
   *
   * - Can only be called by the current owner.
   * - The contract must be frozen.
   */
  function _unfreeze() internal whenFrozen {
    _frozen = false;
    emit Unfrozen(_msgSender());
  }
}