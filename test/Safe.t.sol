// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {Test, console} from "forge-std/Test.sol";

contract Safe {
    mapping(address => uint256) public balances;

    receive() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() external {
        uint256 amount = balances[msg.sender];
        balances[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
}

contract SafeTest is Test {
    Safe safe;
    address constant boss = address(0x111);
    address constant alice = address(0x222);
    address constant bob = address(0x333);
    address[] accounts = [boss, alice, bob];

    // Needed so the test contract itself can receive ether
    // when withdrawing
    receive() external payable {}

    function setUp() public {
        safe = new Safe();
        console.log(address(this).balance);
        console.log(type(uint96).max);
    }

    function test_Withdraw(uint256 accountIndex, uint256 amount) public {
        vm.assume(amount <= type(uint96).max);
        accountIndex = bound(accountIndex, 0, accounts.length - 1);
        address account = accounts[accountIndex];
        payable(account).transfer(amount);
        vm.startPrank(account);
        (address(safe)).call{value: amount}("");
        uint256 preBalance = account.balance;
        safe.withdraw();
        vm.stopPrank();
        uint256 postBalance = account.balance;
        assertEq(preBalance + amount, postBalance);
    }

    function fixtureAmount() public view returns (uint256[] memory r) {
        r = new uint256[](1);
        r[0] = 336;
    }
}
