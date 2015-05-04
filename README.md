# MultiSig
## A mobile, multisignature Bitcoin wallet powered by Coinbase
- [Motivation](#motivation)
- [Libraries Used](#libraries)
- [Architecture](#architecture)
- [Screenshots](#screenshots)
- [Extensions](#extensions)

### Motivation
Multisignature wallets are a huge feature of Bitcoin. The use cases are endless--from multiperson escrow to shared accounts. There is currently no good option for mobile multisignature wallets. 

### Libraries
For dependency management, [Cocoa pods](https://cocoapods.org/) were used. All dependencies can be installed by running `pod install` from the root directory. The project can then be opened with `open MultiSig.xcworkspace`. 

[Core bitcoin](https://github.com/oleganza/CoreBitcoin) was used for all crypto. This library is used to generate hiearchical deterministic wallets (explained in [BIP32](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki)). It is also used to generate key pairs from that wallet, to sign transactions, and read/generate QR codes.

The [Coinbase SDK](https://github.com/joshbeal/coinbase-ios-sdk) is used to interact with a user's Coinbase account. Coinbase is used to keep track of signatures and propogate transactions.

[SSKeychain](https://github.com/soffes/sskeychain) is used to securely store private keys in the iOS keychain. 

### Architecture

This app is a proof of concept that demonstrates multisignature wallets and transactions on an iOS device. First the user creates an account with Coinbase and signs in. Then a public/private keypair is generated on the iOS device. To create a wallet, the other public keys can be scanned via QR codes. The public keys are then sent to Coinbase and a new wallet is created. To spend from the wallet, one of the users creates a new transaction request and sends it to Coinbase. The user can share the transaction id with other members of the wallet for signing. They can fetch the transacrion, sign it, and sned it back to Coinbase. Once enough signatures have been collected, Coinbase executes the transaction. 

### Screenshots

<img src="screenshots/screenshot-1.PNG" alt="Wallet" width="200">
<img src="screenshots/screenshot-2.PNG" alt="New Wallet" width="200">
<img src="screenshots/screenshot-3.PNG" alt="QR" width="200">
<img src="screenshots/screenshot-4.PNG" alt="Sign Transaction" width="200">

### Extensions

* Options for more public keys / required signatures
* Generate new public key
* Display shared account info
* Interface directly with bitcoin network and bypass Coinbase
 
