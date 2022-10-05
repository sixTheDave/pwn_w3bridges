# pwn_w3bridges

Workshop for web3 bridge hacking at Hacktivity 2022


# Scenario 1 - Receipt reuse - Topology

Story: Substrate system being built after ERC20 token is sold.

- Substrate node with EVM pallet || Token minter smart contract (vuln here)
- Bridge providing receipts || Checks bridge balance on Substrate node
- Ethereum node || Token minter smart contract (target for mint)

https://remix.ethereum.org/
Faucet?
https://polkadot.js.org/apps/
https://ethereum.org/en/developers/docs/standards/tokens/erc-20/
https://git.hsbp.org/six/eth_keygen

https://github.com/paritytech/substrate-contracts-node
https://docs.substrate.io/quick-start/
https://substrate.io/developers/playground/ | alternative
https://github.com/substrate-developer-hub/substrate-front-end-template


## Commands
$

# Scenario 2 - ECDSA signature forgery - Topology

Story: ink! smart contract interoperability.

- Substrate node with ink!
- No bridge, but signature forgery
- Ethereum node

https://github.com/paritytech/ink
https://use.ink/getting-started/setup
https://medium.com/block-journal/introducing-substrate-smart-contracts-with-ink-d486289e2b59

## Commands
$
