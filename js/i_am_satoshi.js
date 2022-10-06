'use strict';

// original: https://gist.github.com/indutny/8d0f5376ee643962a9f0

// npm install --save bn.js
// npm install elliptic
// npm install bcoin
// npm install secp256k1

const BN = require('bn.js');
const elliptic = require('elliptic');
const bcoin = require('bcoin');

const ecdsa = new elliptic.ec('secp256k1');

let message = new BN(
    '7a05c6145f10101e9d6325494245adf1297d80f8f38d4d576d57cdba220bcb19', 'hex');

var key = new Buffer('0411db93e1dcdb8a016b49840f8c53bc1eb68a382e97b1482ecad7b148a6909a5cb2e0eaddfb84ccf9744464f82e160bfa9b8b64f9d4c03f999b8643f656b412a3', 'hex');
var sig = '304402204e45e16932b8af514961a1d3a1a25fdf3f4f7732e9d624c6c61548ab5fb8cd410220181522ec8eca07de4860a4acdd12909d831cc56cbbac4622082221a8768d1d09';
// const signature = new bcoin.ecdsa.signature(new Buffer(sig, 'hex'));
// console.log(signature);

var signature = {
  r: new BN('4e45e16932b8af514961a1d3a1a25fdf3f4f7732e9d624c6c61548ab5fb8cd41', 'hex'),
  s: new BN('181522ec8eca07de4860a4acdd12909d831cc56cbbac4622082221a8768d1d09', 'hex')
};

const point = ecdsa.curve.pointFromX(signature.r);
point.precompute(256);

function trick(message, signature, i) {
  const n = new BN(
      'fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141', 16);
  const p = new BN(
      'fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f', 16);

  const nRed = BN.red(n);
  const pRed = BN.red(p);

  // NOTE: Could be using GLV values for speed
  let lambda = new BN(i);

  const point2 = point.mul(lambda);
  let beta = point2.x.redMul(point.x.redInvm()).fromRed();

  lambda = lambda.toRed(nRed);
  beta = beta.toRed(pRed);
  // NOTE end

  const originalR = signature.r;
  const r = originalR.toRed(pRed).redMul(beta).fromRed();

  const nBeta = r.toRed(nRed).redMul(originalR.toRed(nRed).redInvm());
  const common = lambda.redInvm().redMul(nBeta);

  const s = signature.s.toRed(nRed).redMul(common).fromRed();

  return {
    signature: { r: r, s: s },
    message: message.toRed(nRed).redMul(nBeta).fromRed()
  };
}

for (let i = 2; i < 100; i++) {
  const item = trick(message, signature, i);
  console.log(JSON.stringify([
    new Buffer(item.message.toArray()).toString('hex'),
    new Buffer(new bcoin.ecdsa.signature(item.signature).toDER()).toString('hex')
  ]) + ',');
  // ecdsa.verify(item.message, item.signature, key)
}
