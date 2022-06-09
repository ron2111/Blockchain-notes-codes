// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract FallbackExample {
    uint256 public result;

    // Fallback function must be declared as external.
    // we dont add fucntion keyword for recive & fallback as these are special keywords
    fallback() external payable { // whenever we send data with the contract that has no function
                                    // associated with it, we need to declare fallback
        result = 1;          // function
    }

    receive() external payable { // when we recive soem eth without calling a function this code gets triggered
        result = 2;   // gets triggered even if we transact with 0 eth
    }
}

    // Explainer from: https://solidity-by-example.org/fallback/
    // Ether is sent to contract
    //      is msg.data empty?
    //          /   \ 
    //         yes  no
    //         /     \
    //    receive()?  fallback() 
    //     /   \ 
    //   yes   no
    //  /        \
    //receive()  fallback()
