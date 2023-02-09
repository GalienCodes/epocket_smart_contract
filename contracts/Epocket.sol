// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

error Epocket__TransferFailed();
error Epocket__NotOwner();

contract Epocket{

    address private immutable i_owner;

    struct TransactionStruct{
        address from;
        address reciever;
        uint timestamp ;
        string name;
        uint amount;
    }

    mapping(address => TransactionStruct) public  s_addressToTransactionStruct;
    mapping(address => mapping(uint256 => TransactionStruct)) public myTransactions;
    mapping(address => uint256) public transactionCount;

    TransactionStruct[] public transactions;

    // Modifiers
    modifier onlyOwner() {
        if (msg.sender != i_owner) revert Epocket__NotOwner();
        _;
    }

    constructor(){
        i_owner = msg.sender;
    }

    function transferFund(address payable _reciever,string memory _name)external payable{
        require(msg.value > 0,"You can't send 0 ETH");
       
        uint serviceFee = ( msg.value * 5)/100;
        payTo(i_owner, serviceFee);
        payTo(_reciever,(msg.value- serviceFee));

        TransactionStruct memory singleTransaction =TransactionStruct(
            msg.sender,payable(_reciever),block.timestamp,_name,msg.value
        );
        // Add transaction for user
        transactionCount[msg.sender]++; // <-- transacion ID
        myTransactions[msg.sender][transactionCount[msg.sender]] = singleTransaction;
        // Add singleTransaction to the array of all cnotract transactions
        transactions.push(singleTransaction);
    }
    function payTo(address to, uint256 amount) internal {
        (bool success, ) = payable(to).call{value: amount}("");
        require(success);
    }

    function getBalanceAccount() public view returns (uint256){
        return msg.sender.balance;
    }
     function getAllContracTxs() public view returns(TransactionStruct[] memory){
        return transactions;
    }

}