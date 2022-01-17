// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Will {
    address owner;  // address type assigned to variable 'owner'
    uint fortune;
    bool deceased;  //  binary - either true or false

    // payable allows for eth transactions (sending and receiving of ether)
    // constructor: special type of function that will execute upon deploying contract
    // public: type of visibility

    constructor() payable public {       
        owner = msg.sender;     //'msg.sender' represents address that is being called (address of contract owner)
        fortune = msg.value;    //'msg.value' used to reflect ether being sent
        deceased = false;       //'false' set as default as assumption would be that subject is still alive
    }  

    // create modifier so that only person who can call contract is the owner(ability to include conditional statements)
    // modifiers can be used to create exceptions
    modifier onlyOwner {
        require(msg.sender == owner);
        _;  // '_' instructs function to continue running if valid. otherwise, revert to previous function.
    }

    // create modifier so that funds are only allocated in the event that subject is deceased
    modifier statusDeceased {
        require(deceased == true);
        _;
    }

    // array (list of relatives' wallets):
    address payable[] familyWallets;

    //iterating: looping through - process of mapping through is to iterate through storing key value 
    // map through inheritance:
    mapping(address => uint) inheritance;    // (key => value)

    // set inheritance for each address: 
    // function to add individual wallets and amount
    function setInheritance(address payable wallet, uint amount) public onlyOwner { // conditional function - function only works if 'onlyOwner' is true
        // list relatives' wallets
        familyWallets.push(wallet);
        inheritance[wallet] = amount;
    }

    // pay each family member based on individual wallet addresses

    
    // set to private as nobody else should have access to info    
    // modifier 'statusDeceased' has been brought in
    function payout() private statusDeceased {  // conditional function - function only works if 'statusDeceased' is true
        // with for loop, looping through things and settings conditions can be done
        for(uint i=0; i<familyWallets.length; i++) {
            familyWallets[i].transfer(inheritance[familyWallets[i]]); //transferring from contract address to receiver address            
        }
    }

    // akin to a switch to be triggered by external oracle
    function verifiedDeceased() public onlyOwner {
        deceased = true;
        payout();
    }
}