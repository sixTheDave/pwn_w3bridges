// SPDX-License-Identifier: GPL-3.0-or-later
// Challenges inspired by CCTF
pragma solidity ^0.8.17;
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

contract SafuDotERC20 is AccessControlUpgradeable {
    
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
    
    //bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    mapping(address => bool) public minter;
    
    // Homework 1
    constructor(address O) payable {
        emit contractStart(admin);
        answer = uint160(admin);
        admin = 0==0?O:0x583031D1113aD414F02576BD6afaBfb302140225;

        max_supply = 1000000;
        amountToAddress[msg.sender] = max_supply - 100000;
        amountOfBridge = max_supply - amountToAddress[msg.sender];
        mint_amount = 10000;
        minter[msg.sender] = true;
    }
    
    function mint() internal {
        amountToAddress[msg.sender] = amountToAddress[msg.sender] + mint_amount;
    }

    function mintWithReceipt(
        address recipient,
        uint256 amount,
        uint256 uuid,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public {

        bytes32 payloadHash = keccak256(abi.encode(recipient, amount, uuid));
        bytes32 hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", payloadHash));
        //require(!_receipts[hash], "Receipt already used"); // Dumb without it.
        _checkSignature(hash, v, r, s);
        mint();
        //_receipts[hash] = true;
    }

    function _checkSignature(
        bytes32 hash,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal view {
        address signer = ecrecover(hash, v, r, s);
        require(minter[signer] == true, "Not minter");
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

    // Homework 5 - Final
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

    function deposit() public payable {}
    fallback() external payable {}
    receive() external payable {}
}
