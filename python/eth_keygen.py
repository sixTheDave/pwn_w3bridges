#!/usr/bin/python3
# Eth ECDSA key generator, signer and arg recovery for web3 hacking
# Author: six
# References: https://web3py.readthedocs.io/en/stable/web3.eth.account.html?highlight=sign#sign-a-message
# Ethereum Private Keys Directory -> https://privatekeys.pw/keys/ethereum/1

print("\033[38;5;111m\n  " + 16*'=' + "\n  || EthKeyGen  ||\n  " + 16*'=' + "\n\033[0;0m")

from web3.auto import w3
from web3 import Web3
from eth_account.messages import encode_defunct

# Generate signed message and print it out
def generate(_msg, _privkey):
    message = encode_defunct(text=_msg)
    try:
        signed_message =  w3.eth.account.sign_message(message, _privkey)
    except:
        print("Error while signing message. Make sure the private key is in hex and correctly generated.")
        sys.exit()
    print("\033[38;5;111mPrivate key:\033[0;0m      " + _privkey)
    print("\033[38;5;111mRecovered signer:\033[0;0m " + w3.eth.account.recover_message(message, signature=signed_message.signature))
    print("\033[38;5;111mMessage str:\033[0;0m      " + str(message))
    print("\033[38;5;111mSigned message:\033[0;0m   " + str(signed_message))
    return signed_message


# ecrecover in Solidity expects v as a native uint8, but r and s as left-padded bytes32
# Remix / web3.js expect r and s to be encoded to hex. This method does the pad & hex:
def to_32byte_hex(val):
    return Web3.toHex(Web3.toBytes(val).rjust(32, b'\0'))

# Recover for tx
def gen_vrs(signed_message):
    ec_recover_args = (msghash, v, r, s) = (
        Web3.toHex(signed_message.messageHash),
        signed_message.v,
        to_32byte_hex(signed_message.r),
        to_32byte_hex(signed_message.s),)
    print("\n\033[38;5;111mRecovered message hash:\033[0;0m " + ec_recover_args[0])
    print("                     \033[38;5;111mv:\033[0;0m " + str(ec_recover_args[1]))
    print("                     \033[38;5;111mr:\033[0;0m " + ec_recover_args[2])
    print("                     \033[38;5;111ms:\033[0;0m " + ec_recover_args[3])
    print("\033[38;5;111m="*108+"\033[0;0m")

# Generate random string
import string
import random
def random_str(N):
    res = ''.join(random.choices(string.ascii_uppercase + string.digits, k=N))
    return(str(res))

# Generate random eth private key
from eth_account import Account
import secrets
def random_privkey():
    priv = secrets.token_hex(32)
    private_key = "0x" + priv
    acct = Account.from_key(private_key)
    return private_key

# Solidity code example for verification
def print_sol_recovery():
    print('''// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract Recover {
  function ecr (bytes32 msgh, uint8 v, bytes32 r, bytes32 s) public pure
  returns (address sender) {
    return ecrecover(msgh, v, r, s);
  }
}''')

# Take command line arguments for convinience
import argparse
import sys
parser = argparse.ArgumentParser()
parser.add_argument("-d", "--dgen", help="Sign message with default keys", action="store_true")
parser.add_argument("-g", "--gen", help="Sign message, requires -m at least, if no -p is provided then it will be random", action="store_true")
parser.add_argument("-r", "--rgen", help="Sign with random key and msg, provide a number for amount")
parser.add_argument("-p", "--pk", help="Provide private key in hex for signed message generation")
parser.add_argument("-m", "--msg", help="Provide message as string for signed message generation")
parser.add_argument("-s", "--sol", help="Print solidity code for ecrecover", action="store_true")
args = parser.parse_args()

if args.dgen:
    forv = generate("Anything","0000000000000000000000000000000000000000000000000000000000000001") # hex|0x7E5F4552091A69125d5DfCb7b8C2659029395Bdf
    gen_vrs(forv)
    sys.exit()
if args.rgen:
    if int(args.rgen) > 999999:
        print("That is probably too much.")
        sys.exit()
    for i in range(int(args.rgen)):
        forv = generate(random_str(9),random_privkey())
        gen_vrs(forv)
    sys.exit()
if args.gen:
        _pk = str(args.pk)
        if _pk == "None":
            _pk = random_privkey()
        _msg = str(args.msg)
        forv = generate(_msg,_pk)
        gen_vrs(forv)
        sys.exit()
if args.sol:
    print_sol_recovery()
    sys.exit()

forv = generate("Anything","0000000000000000000000000000000000000000000000000000000000000001") # hex|0x7E5F4552091A69125d5DfCb7b8C2659029395Bdf
gen_vrs(forv)
print("\nNo arguments were provided. You can use --help.")
