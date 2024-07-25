// License-SPDX-Identifier: None

pragma solidity 0.8.19;

import "src/ERC20.sol";
import {Test, console} from "forge-std/Test.sol";

contract ERC20Test is Test {
    ERC20 public token;

    function setUp() public {
        token = new ERC20("Test Token", "TST", 18);
    }

    function testTransfer() public {
        uint256 amount = 100;
        uint256 initialBalance = token.balanceOf(address(this));
        token.transfer(address(0x1), amount);
        assertEq(token.balanceOf(address(this)), initialBalance - amount);
        assertEq(token.balanceOf(address(0x1)), amount);
    }

    function testTransfer(address sender, address recipient) public {
        // PRECONDITION: sender must have enough balance
        uint256 amount = 100;
        token.transfer(sender, amount);
        uint256 initialSenderBalance = token.balanceOf(sender);
        uint256 initialRecipientBalance = token.balanceOf(recipient);

        // ACTION
        vm.prank(sender);
        token.transfer(recipient, amount);
        assertEq(token.balanceOf(sender), initialSenderBalance - amount);
        assertEq(token.balanceOf(recipient), initialRecipientBalance + amount);
    }
}
