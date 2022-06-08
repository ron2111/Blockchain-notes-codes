// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SimpleStorage.sol"; // while importing we need to make sure our version of solidity are compatible
contract StorageFactory {
    // making an object sort of think to use anither contract in the current contract
    SimpleStorage[] public simpleStorageArray; // instead making a single variable, we made an array

    function createSimpleStorageContract() public {
        // declaring it
     SimpleStorage simpleStorage = new SimpleStorage();  // now making an element
     simpleStorageArray.push(simpleStorage); // to be pushed in the array
    }

   function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public {
   // in order to interact with any contract, we would always need :
   // Address
   // ABI: Application Binary Interface
      SimpleStorage simpleStorage = simpleStorageArray[_simpleStorageIndex];
      // made an SimpleStorage contract type object whose address will be that in the SimpleStorage 
      // array type contract object.
      simpleStorage.store(_simpleStorageNumber); // then the new contact will store the number provided in the function
   }

// to read the store function from Simple Storage contract
   function sfGet(uint256 _simpleStorageIndex) public view returns(uint256) {
       return simpleStorageArray[_simpleStorageIndex].retrieve();
       
   }

}
