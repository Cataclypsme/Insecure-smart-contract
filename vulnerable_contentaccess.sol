// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/***
*@title A Contract for Giving Learners Authorization Code
*@author Said Habou Adi
*@notice You can use this contract to take advantages of Ethereum Blockchain to give access to course content.
*@dev This contract's main public function takes an input as an argument and generate authorization code.
*/

contract ContentAccess {

    uint[] collectionOfAuthCodes;

    ///@dev Public Keyword helps the compiler generate a function that returns mappings' values.
    mapping(uint => address) public authCodeOwner;
    mapping(address => uint) public authCodeOfLearner;
    mapping(address => uint) authCodeCount;

    uint authCodePrice = 2 * (10 ** 18);

    event NewAuthCodeIsAdded(uint cryptoCode);

    
        ///@notice Changes the price of authorization codes creation.
        ///@dev Takes a wei unit as argument to change the price for generating authorization codes.
    function setauthCodePrice(uint _price) external {
        authCodePrice = _price;
    }

        ///@param inputKeccak The input to be used to generate authorizationcodes
        ///@return Random 9-digits numbers.
    function generateAuthCode(string memory inputKeccak) public pure returns (uint) {
        uint hash = uint(keccak256(abi.encodePacked(inputKeccak)));
        return hash % (10 ** 9);
    }

        ///@notice Takes random numbers and add it to the array.
    function addAuthCode(uint _hashmodulus) public {
        collectionOfAuthCodes.push(_hashmodulus);
        authCodeOwner[_hashmodulus] = msg.sender;
        authCodeOfLearner[msg.sender] = _hashmodulus;
        authCodeCount[msg.sender]++;
        emit NewAuthCodeIsAdded(_hashmodulus);
    }

        ///@notice Creates an authorization code
        ///@dev Takes an input, generate 9-digits number and add it to the array
        ///@param input to be used as an argument by invoked functions
    function createAuthCode(string memory input) external payable {
        require(authCodeCount[msg.sender] == 0);
        require(msg.value == authCodePrice);
       uint randNumber = generateAuthCode(input);
       addAuthCode(randNumber);
    }
                
        ///@notice Returns the number of enrolled learners
        ///@dev Returns a number.
        ///@return Number of student with authorization code.    
    function getNumberOflearners() external view returns (uint) {
        return collectionOfAuthCodes.length;
    }

        ///@notice Function caller receives the money stored in the contract.
    function withdraw() external {
         address payable moneyReceiver = payable(msg.sender); 
        moneyReceiver.transfer(address(this).balance);
    }

        ///@notice Returns all authorization codes.
        ///@dev Returns authorization code stored in the collectionOfAuthCodes array.
        ///@return Authorization codes.
    function getCollectionOfAuthCodes() external view returns(uint[] memory) {
        return collectionOfAuthCodes;
    }   
}
