// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./SimpleStorage.sol";

contract ExtraStorage is SimpleStorage { // Inheritance
  // overriding store function from simple storage contract

// virtual override
  function store(uint256 _favNum) public override { // override keyword used to specify overriden function
      favNum = _favNum + 5;
  }
}
