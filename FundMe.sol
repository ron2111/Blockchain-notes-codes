// get Funds from users
// Withdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

 import "./PriceConverter.sol";
contract FundMe{
using PriceConverter for uint256; // attaching it to uint256
uint256 public minUsd = 50 * 10 ** 18; // to compare properly

 address[] public funders;
 mapping(address => uint256) public addressToAmountFunded; // mapping is like hash table

address public owner; // to setip the owner of contract

      constructor(){ // fucntion that gets called immediately when the contract is deployed
        owner = msg.sender; // so that only the owner can withdraw funds
      }

   function fund() public payable{
// Want to be able to set a minimum   fund amount in USD
// 1. How do we send ETH to ths contract?
    // require(msg.value>1e18, "Didn't send enough");   // 1e18 == 1* 10 **18 == 1000000000000000000
                                               // means 1 ETH = to that much wei
   
    // require(getConversionRate(msg.value)>= minUsd, "Didn't send enough"); 
    //msg.vale gives the native blockchain's value
     
     require(msg.value.getConversionRate() >= minUsd, "Didn't send enough"); // used like this with the help of li brary
// When you call a library function, these functions will receive the object they are called 
// on as their first parameter, much like the variable self in Python


// msg.value represents number of wei sent with the msg
// getConversionRate gives the value in usd
   funders.push(msg.sender);
   addressToAmountFunded[msg.sender] = msg.value; // hey-value pair

 // require keywords makes it necessary to send that much value , if its not sent  its reverted

 // What is reverting?
 // undo any action before, and send remaining gas back

  // What is Chainlink?
  /* Chainlink is a technology for getting external data and doing external computation  
     in a decetralized context for our smart contracts */

  /* Chainlink data feeds or price feeds are ways to read pricing information or ther pieces of 
  data from the real world that's already aggregated and decentralized for us.
  */

/* Channeling VRF is a way to get provably random numbers from the real world into our smart contracts.*/
 
 /* Channeling keepers are a way to do decentralized event driven computation. We can set some
  triggers, say if this trigger hits to do something and we get to define what the trigger and result will be.*/
 
   }

   function getVersion() public view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
    }


    function withdraw() public onlyOwner {

         for(uint256 funderIndex =0;funderIndex<funders.length; funderIndex++){
             address funder = funders[funderIndex]; // storing the address of the current funder
             addressToAmountFunded[funder] = 0; // making its amount 0 (mapping)

         }
         // reset the array
         funders = new address[](0);    // 0 means 0 objects to start with
         // actually withdraw funds
            // Three methods to do this: transfer, send & call
         // transfer
         /*
              msg.sender = address type
              payable(msg.sender) = payable address
         */

       /* payable(msg.sender.transfer(address(this).balance); // 'this' refers to the whole contract here
         // capped at 2300 gas and if fails returns an erro and reverts the transaction

        // send 
         bool sendSuccess = payable(msg.sender).send(address(this).balance);
         require(sendSuccess, "Send failed");
         */

         // call: lower lvl command, can be used to virtually used to call any function without ABI
         (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
         // the bracket left is for , if we want to call any function
         // call function returns two variables, but we only need to use one here
         // call forwards all gas, no capping [RECOMMENDED WAY]
         require(callSuccess, "Call failed");

    }

 modifier onlyOwner { // we can setup customized modifiers for imp properties 
                      // and set it with the required function, just with the use of one word
        require(msg.sender == owner, "Sender is not owner"); // to setup ownership
        _; // it represent doing the rest of the code after the modifier condition is met
        // we can change the position of this _ thing to change the order of processing the function
 }
}
