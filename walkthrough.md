# Fuzzing Workshop 


## Fixtures

- Fixtures are a way to provide a set of inputs to the fuzzer. This is useful when you want to test a function with a set of inputs that are not random. For example, you might want to test a function with a set of inputs that are known to cause a bug.

```solidity
uint256[] public fixtureAmount = [336, 1098, 2113];
```

- Fixtures can be used in the following way: 

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




