// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

error Epocket__TransferFailed();
error Epocket__NotOwner();

contract Epocket{

    struct TransactionStruct{
        address from;
        address reciever;
        uint timestamp ;
        uint amount;
    }

    mapping(address => TransactionStruct) public  s_addressToTransactionStruct;
    mapping(address => mapping(uint256 => TransactionStruct)) public myTransactions;
    mapping(address => uint256) public transactionCount;

    TransactionStruct[] public transactions;

    address private immutable i_owner;

    event transctions(address indexed from, address to, uint amount, string symbol);
    event recipeintTx(address indexed recipientOf,address recipient, string recipientName );

    // Modifiers
    modifier onlyOwner() {
        if (msg.sender != i_owner) revert Epocket__NotOwner();
        _;
    }

    constructor(){
        i_owner = msg.sender;
    }

    function _transfer(address payable _to, string memory symbol) external payable{
        require(msg.value > 0,"You can't send 0 ETH");
       
        uint serviceFee = ( msg.value * 5)/100;
        payTo(i_owner, serviceFee);
        payTo(_to,(msg.value - serviceFee));

        TransactionStruct memory singleTransaction =TransactionStruct(
            msg.sender,payable(_to),block.timestamp,msg.value
        );
        // Add transaction for user
        transactionCount[msg.sender]++; // <-- transacion ID
        myTransactions[msg.sender][transactionCount[msg.sender]] = singleTransaction;
        // Add singleTransaction to the array of all contract txs
        transactions.push(singleTransaction);

        emit transctions( msg.sender,_to, msg.value, symbol);
    }

    function saveTX(address from, address to, uint amount,string memory symbol) public {
       emit transctions(from,to,amount, symbol);
    }
    
    function addRecipeint(address recipient, string memory name) public {
        emit recipeintTx(msg.sender, recipient, name);
    }

    function payTo(address to, uint256 amount) internal {
        (bool success, ) = payable(to).call{value: amount}("");
        if(! success){
           revert Epocket__TransferFailed();
       }
    }

    function getBalanceAccount() public view returns (uint256){
        return msg.sender.balance;
    }

    function getAllContracTxs() public view returns(TransactionStruct[] memory){
        return transactions;
    }

}