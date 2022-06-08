// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

//0.8.12-latest version as of 2-6-2022
//pragma solidity ^0.8.7;  ^ means our contract is comfortable with versions above this too
// pragma solidity >=0.8.7 <0.9.0; if we want to specify range for the versions

contract SimpleStorage {  // similar to class in java
    /* Solidity Value Types:
      boolean, uint, int, address, bytes
    */

/*
    bool hasFavNum = true;
    uint favNum = 123; // we can specify the number of bits to allocate this variable like uint8 / uint256
 // uint means unsigned means it can only take up +ve value and by default unit means uint256
    int favInum = -231; // int is used for signed integer
    string favText = "Five";
    address myAddress = 0x347eDbD68Cc744754bD4c49bFa1c9Ba9843367a6;
    bytes32 favBytes = "cat";
*/

uint256 favNum; // initialized to 0
// People public person = People({favNum: 2, name: "Patrick"});

mapping(string => uint256) public nameToFavNum; // mapping variable

struct People {
    uint256 favNum;
    string name;
}
// uint[] public favNumber;   uint256 array
 People[] public people; // struct array -- Dynamic array as size is not fixed

function store(uint256 _favNum ) public virtual { // virtual keyword used to make this function overridable
    favNum = _favNum;
    retrieve();
}

// view & pure functions are free in terms of gas unless called inside a fuction that costs gas
function retrieve() public view returns(uint256) {
    return favNum;
}
// View functions are read only function and do not modify the state of the block chain 
//(view data on the block chain). Pure functions do not read and do not modify state of the block 
// chain. All the data the pure function is concerned with is either passed in or defined in the functions scope.

// memory, storage, calldata
// sorage is used to specify storing n permanenet storage
// calldata for temp storage which can't be modified
 function addPerson(string memory _name, uint256 _favNum) public {
     // memory is used t specifyt that the variable neeeds to be stored in temp storage that can be modified
     // and it is used for string _name here, as we need specification for special types of data, like arrays
     // and other mapping types like struct and here string is an array of bytes.

     people.push(People(_favNum, _name));
     // or we can do like this too:
    //  People memory newPerson = People({favNum: _favNum,name: _name});
    //  people.push(newPerson);

    nameToFavNum[_name] = _favNum;
 }


}

// 0xd9145CCE52D386f254917e481eB44e9943F39138
