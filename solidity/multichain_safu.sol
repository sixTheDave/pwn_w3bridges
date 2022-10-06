// SPDX-License-Identifier: GPL-3.0-or-later
// Challenges inspired by CCTF
pragma solidity ^0.8.17;

contract SafuDotERC20 {
    
    uint256 public max_supply;
    mapping (address => uint256) internal amountToAddress;
    uint256 public amountOfBridge;
    uint256 public mint_amount;
    string private correct_password;
    //mapping(bytes32 => bool) public hashes;

    uint160 answer = 0;
    address private admin = 0xdD870fA1b7C4700F2BD7f44238821C26f7392148;
    event contractStart(address indexed _admin);
    mapping(address => uint256) public calls;
    mapping(address => uint256) public tries;
    
    address public bridge;
    mapping(address => bool) public minter;
    
    // Homework 1
    constructor(address O) payable {
        emit contractStart(admin);
        answer = uint160(admin);
        admin = 0==0?O:0x583031D1113aD414F02576BD6afaBfb302140225;

        max_supply = 1000000;
        amountToAddress[msg.sender] = max_supply - 100000;
        bridge = 0xE57bFE9F44b819898F47BF37E5AF72a0783e1141;
        amountToAddress[bridge] = max_supply - amountToAddress[msg.sender];
        mint_amount = 10000;
        
        minter[msg.sender] = true;
    }
    
    function mint() internal {
        amountToAddress[msg.sender] = amountToAddress[msg.sender] + mint_amount;
    }

    function mintWithReceipt(bytes32 _message, bytes memory _signature) public {
        require(recoverSigner(_message, _signature) == bridge, "Not signed with the correct key.");
        //require(minter[msg.sender] == true, "Not minter");
        //require(!_receipts[hash], "Receipt already used"); // Dumb without it.
        amountToAddress[bridge] = amountToAddress[bridge] - mint_amount;
        require(amountToAddress[bridge] >= 0);
        mint();
        //_receipts[hash] = true;
    }

    function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature) public pure returns (address) {
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    function splitSignature(bytes memory sig) public pure returns (bytes32 r, bytes32 s, uint8 v){
        require(sig.length == 65, "Invalid signature length");
        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }
    }

    function myBalance() external view returns (uint256) {
        return amountToAddress[msg.sender];
    }


    function othersBalance(address _other) external view returns (uint256) {
        return amountToAddress[_other];
    }

    function transfer(uint256 _value, address _toAddress) external {
        require(amountToAddress[msg.sender] - _value >= 0, 'Oooops');
        amountToAddress[_toAddress] = amountToAddress[_toAddress] + _value;
    }

    function adminWithdraw() external returns (bool) {
        require(msg.sender == admin, 'You are not the central admin!');
        (bool sent,) = msg.sender.call{value: address(this).balance}("");
        return sent;
    }

    // Easypeasy
    function adminChange(address _newAdmin) external returns (bool) {
        admin = _newAdmin;
        return true;
    }

    // Homework 2
    function set_password(string memory _password) external {
        require(msg.sender == admin, 'You are not the central admin!');
        correct_password = _password;
    }

    // Homework 6 - Final
    function su1c1d3(address payable _addr, string memory _password) external {
        require(msg.sender == admin, 'You are not the central admin!');
        require(keccak256(abi.encodePacked(correct_password)) == keccak256(abi.encodePacked(_password)), 'Very sekur.');
        selfdestruct(_addr);
    }
    
    // Homework 3
    function callOnlyOnce() public {
        require(tries[msg.sender] < 1, "No more tries");
        calls[msg.sender] += 1;
        answer = answer ^ uint160(admin);
        (bool sent, ) = msg.sender.call{value: 1}("");
        require(sent, "Failed to call");
        tries[msg.sender] += 1;
    }

    // Homework 4
    function answerReveal() public view returns(uint256 ) {
        require(calls[msg.sender] == 2, "Try more :)");
        return answer;
    }

    // Homework 5
    mapping(address => bool) address_contributed;
    function deposit() public payable {
            require(address_contributed[msg.sender] != true, "Not working.");
            address_contributed[msg.sender] = true;
    }
    fallback() external {}
    //receive() external {}
}
