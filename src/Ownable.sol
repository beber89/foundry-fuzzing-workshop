// SPDX-License-Identifier: None

pragma solidity 0.8.19;

contract Ownable {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        owner = address(0);
    }

    function transferOwnership(address _newOwner) public virtual onlyOwner {
        _transferOwnership(_newOwner);
    }

    function _transferOwnership(address _newOwner) internal {
        owner = _newOwner;
    }
}
