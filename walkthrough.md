# Fuzzing Workshop 


## Getting started

- Create a new foundry project inside a new directory.

```bash
forge init
```

- Test the `withdraw` function in the `Safe` contract (test/Safe.t.sol) using the foundry fuzzer.

```solidity
    address constant boss = address(0x111);
    address constant alice = address(0x222);
    address constant bob = address(0x333);
    address[] accounts = [boss, alice, bob];
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
```

- Make sure your `foundry.toml` file has the following configuration:

```toml
[fuzz]
runs = 128 
```
- A default value of `256` is used if the `runs` field is not specified.

- Run the test using the `forge` tool. Running the fuzz test is similar to running a regular test.

```bash
forge test -vvvv --match-path test/Safe.t.sol
```

- The fuzzer will run the test multiple times with different inputs to try to find bugs in the `withdraw` function. To put a constraint on the values of `amount` to be within a certain range, you can use the `vm.assume` function.

```solidity
vm.assume(amount <= type(uint96).max);
```

- The `vm.assume` function is used to tell the fuzzer that the value of `amount` should be less than or equal to `type(uint96).max`. This is useful when you want to test a function with a specific range of inputs. 

- The `bound` function is used to ensure that the value of `accountIndex` is within the bounds of the `accounts` array.

```solidity
accountIndex = bound(accountIndex, 0, accounts.length - 1);
```

- `vm.assume` rejects test runs that do not satisfy the condition. `bound` is a helper function that ensures that the value of `accountIndex` is within the bounds of the `accounts` array and do not reject the test runs. Rejecting too many runs might cause the fuzzer to fail and it also reduces the effectiveness of the fuzzer.



## Fixtures

- Fixtures are a way to provide a set of inputs to the fuzzer. This is useful when you want to test a function with a set of inputs that are not random. For example, you might want to test a function with a set of inputs that are known to cause a bug.

```solidity
uint256[] public fixtureAmount = [336, 1098, 2113];
```

- Fixtures can be used as well in the following way: 

```solidity
function fixtureAmount() public view returns (uint256[] memory fixture_) {
    fixture_ = new uint256[](3);
    fixture_[0] = 336;
    fixture_[1] = 1098;
    fixture_[2] = 2113;
}
```

## Exercise

- In this exercise, you will test a buggy ERC20 token contract using the foundry fuzzer. 

```solidity
pragma solidity 0.8.19;

import "src/ERC20.sol";
import {Test, console} from "forge-std/Test.sol";

contract ERC20Test is Test {
    ERC20 public token;

    function setUp() public {
        token = new ERC20("Test Token", "TST", 18);
    }

    function testTransfer(address sender, address recipient) public {
        // PRECONDITION: sender must have enough balance
    }
}
```


## Coverage

- Coverage is a measure of how much of your code is being executed by the fuzzer. It is important to have high coverage because it means that you are testing more of your code and therefore more likely to find bugs.

- To measure coverage, you can use the `coverage` command in the `forge` tool. This will generate a coverage report (e.g. lcov.info) that shows which lines of code have been executed by the fuzzer.

```bash
forge coverage --report lcov 

```

- You can then use the `genhtml` command to generate a human-readable coverage report. This will show you which lines of code have been executed by the fuzzer and which have not.

```bash
genhtml lcov.info --branch-coverage --output-dir coverage
```

- Open the `index.html` file in the `coverage` directory to view the coverage report.




