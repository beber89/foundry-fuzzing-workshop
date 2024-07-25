// SPDX-License-Identifier: None

pragma solidity 0.8.19;

import {Test, console} from "forge-std/Test.sol";

interface IWeth {
    function deposit() external payable;

    function withdraw(uint256 amount) external;

    function balanceOf(address account) external view returns (uint256);
}

contract WethTest is Test {
    address constant WETH_ADDRESS = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    IWeth weth;

    receive() external payable {}

    function setUp() public {
        string memory url = vm.envString("RPC_URL");
        uint256 mainnetFork = vm.createFork(url);
        weth = IWeth(WETH_ADDRESS);
        vm.selectFork(mainnetFork);
    }

    function test_deposit(uint256 amount) public {
        vm.assume(amount <= type(uint96).max);
        weth.deposit{value: amount}();
        uint256 wethBalance = weth.balanceOf(address(this));
        assertEq(wethBalance, amount);
    }

    function test_depositWithReceive(uint256 amount) public {
        vm.assume(amount <= type(uint96).max);
        address(weth).call{value: amount}("");
        uint256 wethBalance = weth.balanceOf(address(this));
        assertEq(wethBalance, amount);
    }

    function test_withdraw(uint256 amount) public {
        vm.assume(amount <= type(uint96).max);
        weth.deposit{value: amount}();
        weth.withdraw(amount);
        uint256 wethBalance = weth.balanceOf(address(this));
        assertEq(wethBalance, 0);
    }
}
