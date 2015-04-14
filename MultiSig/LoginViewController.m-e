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
#import <SSKeychain/SSKeychain.h>
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
-(void)didPressLogin
{
    [_defaults synchronize];
    if (![_defaults objectForKey:@"user_id"])
    {
        [CoinbaseOAuth startOAuthAuthenticationWithClientId:@"api_id"
                                                      scope:@"user balance"
                                                redirectUri:@"edu.self.multisig.coinbase-oauth://coinbase-oauth"
                                                       meta:nil];
    }
    else
    {
        Coinbase *apiClient = [Coinbase coinbaseWithOAuthAccessToken:[SSKeychain passwordForService:@"access_token" account:[_defaults objectForKey:@"user_id"]]];
        [CoinbaseSingleton shared].client = apiClient;
        [self didFinishAuthentication];
    }
}

-(void) didFinishAuthentication {
    NSString *user_id = [_defaults objectForKey:@"user_id"];
    if (![SSKeychain passwordForService:@"extended_public_key" account:user_id])
    {
        //Create extended public and private key
        NSData* seed = BTCDataWithHexCString([[self randomStringWithLength:32] UTF8String]);
        BTCKeychain* masterChain = [[BTCKeychain alloc] initWithSeed:seed];
        [SSKeychain setPassword:masterChain.extendedPublicKey forService:@"extended_public_key" account:user_id];
        [SSKeychain setPassword:masterChain.extendedPrivateKey forService:@"extended_private_key" account:user_id];
        
    }
    // output public key (make sure it's there)
    NSLog(@"%@", [SSKeychain passwordForService:@"extended_public_key" account:user_id]);
    [self dismissViewControllerAnimated:YES completion:nil];
}



-(NSString *) randomStringWithLength: (int) len {
    NSString *letters = @"0123456789abcdef";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString;
}

@end
