// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol"; // importing directly from fitub(npm package)

// Why is this a library and not abstract?
// Why not an interface?
library PriceConverter { // library cant have state variables and cant send ether too
    // We could make this public, but then we'd have to deploy it

    function getPrice() internal view returns (uint256) {
// Since we are working on an instance of an contract outside of our project, we would need:
// ABI 
// Address : 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
// Address can be found on chainlin -> data feeds -> ethereum data feeds -> copy ETH/USD address

  AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
  // We made an object(priceFeed) of the AggregatorV3Interface using the address
  (, int256 price, , , ) = priceFeed.latestRoundData(); // then called the required function
  // as the function returns many things but we need only the "price", hence taking that only
  // ETH in terms of USD

  return uint256(price * 10000000000); // 1e10 = 1**10 to convert the value that makes it similar to Wei
                 // as the price returned has 8 decimals originally
}

  function getVersion() public view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
    }
    
    function getConversionRate(uint256 ethAmount) 
      internal 
      view 
      returns (uint256) 
    { // function to get the worth of eth in usd
      uint256 ethPrice = getPrice();
      uint256 ethAmountInUsd = (ethPrice * ethAmount) /1000000000000000000; // divided by 1e18 so that 18 zeores are not added 2 times
       return ethAmountInUsd;
}
}
