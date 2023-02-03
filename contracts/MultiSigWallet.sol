//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract MultiSigWallet {
    using SafeMath for uint256;

    event Confirm (address indexed sender, uint indexed txId);
    event Revoke (address indexed sender, uint indexed txId);
    event Submit (uint indexed txId);
    event Execute (uint indexed txId);
    event ExecuteFail (uint indexed txId);
    event Deposit (address indexed sender, uint value);
    event AddOwner (address indexed owner);
    event DeleteOwner (address indexed owner);
    event TransferOwner (address indexed owner, address indexed newOwner);
    event AdjustRequirement (uint required);


    uint constant public MAX = 100;

    address currentWallet;

    address[] public owners;
    uint256 public required;
    uint256 public txCount;

    struct Transaction {
        address dest;
        uint value;
        bytes data;
        bool executed;
    }

    mapping (uint => Transaction) public transactions;
    mapping (uint => mapping ( address => bool)) confirmations;
    mapping (address => bool) public isOwner;



    fallback() external payable {
        if(msg.value>0){
            emit Desposit(msg.sender, msg.value);
        }
    }

    receive() external payable {
        if(msg.value>0){
            emit Deposit(msg.sender, msg.value);
        }
    }

    modifier onlyCurrentWallet(){
        require(msg.sender == currentWallet, "Only current wallet can access!");
        _;
    }

    modifier notOwner(address owner){
        require(!isOwner[owner], "You are an owner");
        _;
    }

    modifier yesOwner(address owner){
        require(isOwner[owner], "You are not an owner");
        _;
    }

    modifier txExists (uint txId){
        require(transactions[txId].dest!=address(0x0),"Transaction does not exist");
        _;
    }

    modifier confirmation (uint txId, address owner){
        require(confirmations[txId][owner]==true,"Transaction not yet confirmed");
        _;
    }

    modifier notConfirmed (uint txId, address owner){
        require(confirmations[txId][owner]==false,"Transaction is confirmed");
        _;
    }

    modifier notExecuted(uint txId){
        require(!transactions[txId].executed, "Transaction is executed!");
        _;
    }

    modifier notNull(address _address){
        require(_address!=address(0x0),"Please enter a valid address");
        _;
    }

    modifier validRequirement (uint ownerCount, uint _required){
        require(ownerCount<=MAX && _required<=ownerCount && _required!=0 && ownerCount!=0);
        _;
    }
    constructor (address[] memory _owners, uint256 _required){
        currentWallet = msg.sender;
        require(_owners.length>=3,
        "There needs to be atleast 3 people signing on the wallet");
        for(uint256 i =0; i<_owners.length;i++){
            require(!isOwner[_owners[i]]&&_owners[i]!=address(0x0));
            isOwner[_owners[i]] = true;
        }
        owners=_owners;
        uint256 percent = SafeMath.mul(owners.)
    }


}