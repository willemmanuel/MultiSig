# MultiSig
## A mobile, multisignature Bitcoin wallet powerd by Coinbase
- [Motivation](#motivation)
- [Libraries Used](#libraries)
- [Architecture](#architecture)
- [Screenshots](#screenshots)
- [Extensions](#extensions)

### Motivation
Multisignature wallets are a huge feature of Bitcoin. The use cases are endless--from multiperson escrow to There is currently no good option for mobile multisignature wallets. 

### Libraries
For dependency management, [Cocoa pods](https://cocoapods.org/) were used. All dependencies can be installed by running `pod install` from the root directory. The project can then be opened with `open MultiSig.xcworkspace`. 

[Core bitcoin](https://github.com/oleganza/CoreBitcoin) was used for all crypto. This library is used to generate hiearchical deterministic wallets (explained in [BIP32](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki)). It is also used to generate key pairs from that wallet, to sign transactions, and read/generate QR codes.

The [Coinbase SDK](https://github.com/joshbeal/coinbase-ios-sdk) is used to interact with a user's Coinbase account. Coinbase is used to keep track of signatures and propogate transactions.

[SSKeychain](https://github.com/soffes/sskeychain) is used to securely store private keys in the iOS keychain. 

### Architecture
This app is a proof of concep

### Screenshots

### Extensions
