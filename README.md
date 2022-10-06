# pwn w3bridges
Workshop for "web3" bridge hacking at Hacktivity 2022

## Agenda

#### Introduction
- Web3 vs web2 hacking, concepts / workshop topology
- Who interacted with dApps/SCs before? 
- Who codes Solidity?
- Who codes Rust?
- Who used a bridge before?
- Who is the cryptographer?

#### Environment setup, system requirements
- Any browser for Ethereum, Remix
- Python3
- Substrate, Rust nightly

#### Scenario 1: Token on two chains, mint using receipt
- Solidity basics, using remix for compile
- Exploit visibility, take admin
- ECDSA Ethereum basics
- Mint with receipt -> Find the vuln!

#### Scenario 2: Signature forgery (any chain)
- Deploy SC on Ethereum chain
- Compile Substrate with EVM
- Deploy SC on Substrate chain (so it is different from core)
- Test ECDSA signature forgery exploit from one to other
- Test same issue with WASM/ink!

## Resources

#### Scenario 1
https://remix.ethereum.org/
https://www.tutorialspoint.com/solidity/solidity_operators.htm
https://polkadot.js.org/apps/
https://ethereum.org/en/developers/docs/standards/tokens/erc-20/
https://git.hsbp.org/six/eth_keygen

#### Scenario 2
https://cryptoctf.org/2022/09/11/writeup-of-flag-submission-forgery-by-si/
https://github.com/paritytech/substrate-contracts-node
https://docs.substrate.io/quick-start/
https://github.com/substrate-developer-hub/substrate-front-end-template
https://github.com/paritytech/ink
https://github.com/paritytech/substrate/blob/master/primitives/core/src/ecdsa.rs
https://use.ink/getting-started/setup
https://medium.com/block-journal/introducing-substrate-smart-contracts-with-ink-d486289e2b59
https://github.com/paritytech/contracts-ui
https://contracts-ui.substrate.io/?rpc=wss://rpc.shibuya.astar.network
https://substrate.io/developers/playground/
https://security.stackexchange.com/questions/200682/is-it-possible-to-fake-ecdsa-signatures


## Solidity Hacking Homework

1. Crypto Wojak - Who is the admin?
2. Sminem       - Set the password
3. Crypto Wojak - Make your tries count 2 or more
4. Crypto Wojak - Make your tries count 2 and get the answer
5. HODLer       - Deposit ether twice with the same address
6. Crypto Wojak - Execute selfdestruct()
+1 Sminem       - Create a signature to prove you are Satoshi (see js folder)
