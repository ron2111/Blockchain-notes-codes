// get Funds from users
// Withdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

// constant & immutable keyword to reduce gas cost
 import "./PriceConverter.sol";

 error NotOwner(); // error seclaration, can work in place of require statements when condition fails

contract FundMe{
using PriceConverter for uint256; // attaching it to uint256
uint256 public constant MIN_USD = 50 * 10 ** 18; // to compare properly
// saved gas using 'constant' as it doesnt need to change & hence takes no storage spot
// naming convention for constant variables - All caps with _  [Saved arounf a $ of ETH]

 address[] public funders;
 mapping(address => uint256) public addressToAmountFunded; // mapping is like hash table

address public immutable i_owner; // to setup the owner of contract
// 'immutable' are also set one time but outside the line they are declared
// naming convention: start the nam with 'i_'

      constructor(){ // fucntion that gets called immediately when the contract is deployed
        i_owner = msg.sender; // so that only the owner can withdraw funds
        // cant modify it now, as its immutable
      }

   function fund() public payable{
// Want to be able to set a minimum   fund amount in USD
// 1. How do we send ETH to ths contract?
    // require(msg.value>1e18, "Didn't send enough");   // 1e18 == 1* 10 **18 == 1000000000000000000
                                               // means 1 ETH = to that much wei
   
    // require(getConversionRate(msg.value)>= minUsd, "Didn't send enough"); 
    //msg.vale gives the native blockchain's value
     
     require(msg.value.getConversionRate() >= MIN_USD, "Didn't send enough"); // used like this with the help of li brary
// When you call a library function, these functions will receive the object they are called 
// on as their first parameter, much like the variable self in Python


// msg.value represents number of wei sent with the msg
// getConversionRate gives the value in usd
   funders.push(msg.sender);
   addressToAmountFunded[msg.sender] += msg.value; 

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

        // require(msg.sender == i_owner, "Sender is not owner"); // to setup ownership
          if(msg.sender != i_owner) {    // can be used in place of the above require statement
              revert NotOwner();        // saves gas
          }
        _; // it represent doing the rest of the code after the modifier condition is met
        // we can change the position of this _ thing to change the order of processing the function
 }

 // What happens if someone sends this contract ETH without calling the fund function
  
   receive() external payable {
       fund();
   }

   fallback() external payable {
       fund();
   }
}
