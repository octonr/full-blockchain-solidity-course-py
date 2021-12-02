// SPDX-License-Identifer: MIT

pragma solidity ^0.6.0;

contract SimpleStorage {
    // Variables Type Tutorial
    // uint256 favoriteNumber = 5;
    // bool favoriteBool = true;
    // string favoriteString = "String";
    // int256 favoriteInt = -5;
    // address favoriteAddress = 0xBa602C61F879925af85dcE1Dd844d04A66ce4544;
    // bytes32 favoriteBytes = "cat";
    
    // Function Tutorial
    uint256 favoriteNumber;
    bool favoriteBool;

    struct People {
        uint256 favoriteNumber;
        string name;
    }

    People[] public people;
    mapping(string => uint256) public nameToFavoriteNumber;

    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }

    function retrieve() public view returns(uint256){
        return favoriteNumber;
    }

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        //people.push(People({favoriteNumber: _favoriteNumber, name: _name}));
        people.push(People(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}