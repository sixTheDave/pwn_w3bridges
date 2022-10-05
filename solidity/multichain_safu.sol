// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.11;
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

contract SafuDotNFT is AccessControlUpgradeable {
    uint256 public maxNFTs;
    uint256 public NFTCount;
    uint256 public NFTPrice;
    mapping (uint256 => string) internal idToHash;
    mapping (uint256 => address) internal idToOwner;
    uint256 public blockTime;
    string private correct_password;

    // Part inspired by CCTF
    uint160 answer = 0;
    address private admin = 0xdD870fA1b7C4700F2BD7f44238821C26f7392148;
    event contractStart(address indexed _admin);
    mapping(address => uint256) public calls;
    mapping(address => uint256) public tries;
    
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    
    constructor(address O) payable {
        emit contractStart(admin);
        answer = uint160(admin);
        admin = 0==0?O:0x583031D1113aD414F02576BD6afaBfb302140225;
        maxNFTs = 99;
        NFTCount = 0;
        NFTPrice = 10000000000000000;
        blockTime = block.timestamp;
        _setupRole(MINTER_ROLE, admin);
    }
    
    function mint(string memory _hashu) public payable {
        require(msg.sender == admin, 'You are not the central admin!');
        require(blockTime <= block.timestamp + 5 minutes, 'Chill bro!');
        require(NFTCount <= 99, 'You shall not pass! All NFTz are minted!');
        require(msg.value >= NFTPrice, 'Where are da fundz?');
        blockTime = block.timestamp;
        NFTCount = NFTCount + 1;
        NFTPrice = NFTPrice * 2;
        idToOwner[NFTCount] = msg.sender;
        idToHash[NFTCount] = _hashu;
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
        mint("mintWithReceipt");
        //_receipts[hash] = true;
    }

    function _checkSignature(
        bytes32 hash,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal view {
        address signer = ecrecover(hash, v, r, s);
        require(hasRole(MINTER_ROLE, signer), "Signature invalid");
    }


    function transfer(uint256 _tokenId, address _toAddress) external {
        require(msg.sender == idToOwner[_tokenId], 'But it is not yours!');
        idToOwner[_tokenId] = _toAddress;
    }

    function adminWithdraw() external returns (bool) {
        require(msg.sender == admin, 'You are not the central admin!');
        (bool sent,) = msg.sender.call{value: address(this).balance}("");
        return sent;
    }

    function WhoGotchaThat(uint256 _whichOne) public view returns (address) {
        return(idToOwner[_whichOne]);
    }

    function WhatIsTheHash(uint256 _tokenId) public view returns (string memory){
        return(idToHash[_tokenId]);
    }

    function adminChange(address _newAdmin) external returns (bool) {
        require(blockTime <= block.timestamp + 6 minutes, 'Welcome to the game!');
        admin = _newAdmin;
        return true;
    }


    function set_password(string memory _password) external {
        require(msg.sender == admin, 'You are not the central admin!');
        correct_password = _password;
    }

    function su1c1d3(address payable _addr, string memory _password) external {
        require(msg.sender == admin, 'You are not the central admin!');
        require(keccak256(abi.encodePacked(correct_password)) == keccak256(abi.encodePacked(_password)), 'Very sekur.');
        selfdestruct(_addr);
    }
    
    function callOnlyOnce() public {
        require(tries[msg.sender] < 1, "No more tries");
        calls[msg.sender] += 1;
        answer = answer ^ uint160(admin);
        (bool sent, ) = msg.sender.call{value: 1}("");
        require(sent, "Failed to call");
        tries[msg.sender] += 1;
    }

    function answerReveal() public view returns(uint256 ) {
        require(calls[msg.sender] == 2, "Try more :)");
        return answer;
    }

    function deposit() public payable {}
    fallback() external payable {}
    receive() external payable {}
}
