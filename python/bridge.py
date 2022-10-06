#!/usr/bin/python3
# Author: six
# Made for: CCTF during BsidesBUD 2022 -> Updated for Hacktivity 2022 web3 hacking Workshop

# require(owner() == ecrecover(keccak256(abi.encodePacked(this, tokenId)), v, r, s), "Should be signed correctly");
# https://privatekeys.pw/keys/ethereum/1

from web3.auto import w3
from eth_account.messages import encode_defunct
from flask import Flask, request

app = Flask(__name__)

html = '''<html><body><pre>Use /get_a_receipt
</pre></body></html>'''

@app.route('/')
def hello():
    return html

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
