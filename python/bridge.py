#!/usr/bin/python3

# Author: six
# Made for: CCTF during BsidesBUD 2022

# require(owner() == ecrecover(keccak256(abi.encodePacked(this, tokenId)), v, r, s), "Should be signed correctly");
# https://privatekeys.pw/keys/ethereum/1

from web3.auto import w3
from eth_account.messages import encode_defunct
from flask import Flask, request

from base64 import b64encode

app = Flask(__name__)

b64 = '''<html><body><pre>Lets play a game... what is the private key if:

SignedMessage(messageHash=HexBytes('0xd65fc3b188dd92cfcb2a193a50840c1b782030fb06c5eee3125dadc48b9042ee'), r=93061353422229139783272046072373682100846510432479107335894930000050943813187, s=18897300799783892124841480819482900155126442998358954848148962214377508383077, v=28, signature=HexBytes('0xcdbedc050cdf4e1a236535365e1563312905fc47aa8238a8ab06decfbb31e64329c77e43945949494800d0c432d037867ea10aad935abf98c63ae2befaf929651c'))

If you send the correct private key as argument to /verify?p=<ARG> in HEX format (without 0x), then you will get the CCTF flag which lets you in to the next yacht event + swag at BsidesBUD.
</pre></body></html>'''

@app.route('/')
def hello():
    return b64

@app.route('/verify', methods=['GET'])
def search():
    args = request.args
    args.get("v", default="", type=str)
    print(args)

    msg = "1" 
    private_key = "0000000000000000000000000000000000000000000000000000000000000006" # <- hex | pub -> 0xE57bFE9F44b819898F47BF37E5AF72a0783e1141
    message = encode_defunct(text=msg)
    signed_message =  w3.eth.account.sign_message(message, private_key=private_key)
    print(signed_message)
    p = args.get('p')
    if p == None:
        return "Please specify ?p"
    if p == private_key:
        return "CCTF{w3lc0m3_t0_th3_y4xx} --> take this flag to six or ra33it0 at BsidesBUD 2022 and he will announce you as the winner if you are the fastest. If you are not there physically, use Matrix, but then you will miss the swag!"
    return "Wrong key."

if __name__ == '__main__':
    app.run(debug=False)
