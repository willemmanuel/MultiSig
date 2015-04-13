//
//  ViewController.m
//  MultiSig
//
//  Created by William Emmanuel on 3/30/15.
//  Copyright (c) 2015 William Emmanuel. All rights reserved.
//

#import "LoginViewController.h"
#import <coinbase-official/CoinbaseOAuth.h>
#import "CoinbaseSingleton.h"
#import "MainTabViewController.h"

#import <CoreBitcoin/CoreBitcoin.h>

@interface LoginViewController ()

@end

@implementation LoginViewController {
    NSUserDefaults *_defaults;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_loginButton addTarget:self action:@selector(didPressLogin) forControlEvents:UIControlEventTouchUpInside];
    _defaults = [NSUserDefaults standardUserDefaults];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)didPressLogin {
    [_defaults synchronize];
    if ([_defaults objectForKey:@"access_token"] == nil) {
        [CoinbaseOAuth startOAuthAuthenticationWithClientId:@"api_id"
                                                      scope:@"user balance"
                                                redirectUri:@"edu.self.multisig.coinbase-oauth://coinbase-oauth"
                                                       meta:nil];
    } else {
        Coinbase *apiClient = [Coinbase coinbaseWithOAuthAccessToken:[_defaults objectForKey:@"access_token"]];
        [CoinbaseSingleton shared].client = apiClient;
        [self didFinishAuthentication];
    }
}

-(void) didFinishAuthentication {
    if ([_defaults objectForKey:@"public_key"] == nil) {
        
        //Create extended public and private key
        NSData* seed = BTCDataWithHexCString("000102030405060708090a0b0c0d0e0f");
        BTCKeychain* masterChain = [[BTCKeychain alloc] initWithSeed:seed];
        
        [_defaults setValue:masterChain.extendedPrivateKey forKey:@"private_key"];
        [_defaults setValue:masterChain.extendedPublicKey forKey:@"public_key"];
        [_defaults synchronize];
    }
    // output public key (make sure it's there)
    NSLog(@"%@", [_defaults objectForKey:@"public_key"]);
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
