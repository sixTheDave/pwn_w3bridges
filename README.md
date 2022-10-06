# pwn w3bridges
Workshop for "web3" bridge hacking at Hacktivity 2022

## Agenda

#### Introduction
- Web3 vs web2 hacking, concepts / workshop topology

#### Environment setup, system requirements
- Any browser for Ethereum, Remix
- Substrate, Rust nightly

#### Scenario 1: Token on two chains, mint using receipt
- Solidity basics, using remix for compile
- Exploit visibility, take admin
- ECDSA Ethereum basics
- Mint with receipt -> Find the vuln!

#### Scenario 2: Signature forgery (any chain)
- Deploy SC on Ethereum chain
- Compile Substrate with EVM
- Deploy SC
- Test ECDSA signature forgery exploit from one to other

## Resources

#### Scenario 1
https://remix.ethereum.org/
https://www.tutorialspoint.com/solidity/solidity_operators.htm
https://polkadot.js.org/apps/
https://ethereum.org/en/developers/docs/standards/tokens/erc-20/
https://git.hsbp.org/six/eth_keygen

#### Scenario 2
https://github.com/paritytech/substrate-contracts-node
https://docs.substrate.io/quick-start/
https://github.com/substrate-developer-hub/substrate-front-end-template
https://github.com/paritytech/ink
https://github.com/paritytech/substrate/blob/master/primitives/core/src/ecdsa.rs
https://use.ink/getting-started/setup
https://medium.com/block-journal/introducing-substrate-smart-contracts-with-ink-d486289e2b59
https://substrate.io/developers/playground/
