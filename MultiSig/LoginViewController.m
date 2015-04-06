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

#import <CoreBitcoin/BTCKey.h>

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
    [_loginButton setTitle:@"Logging in..." forState:UIControlStateNormal];
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
        BTCKey *newKey = [[BTCKey alloc] init];
        // not very secure right now. fix later with keychain implementation
        [_defaults setValue:[newKey privateKey] forKey:@"private_key"];
        [_defaults setValue:[newKey publicKey] forKey:@"public_key"];
        [_defaults synchronize];
        newKey = nil;
    }
    // output public key (make sure it's there)
    NSLog(@"%@", [_defaults objectForKey:@"public_key"]);
    [[CoinbaseSingleton shared].client doGet:@"accounts" parameters:nil completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"Could not load: %@", error);
        } else {
            NSArray *accounts = result[@"accounts"];
            NSString *text = @"";
            for (NSDictionary *account in accounts) {
                NSString *name = account[@"name"];
                NSDictionary *balance = account[@"balance"];
                text = [text stringByAppendingString:[NSString stringWithFormat:@"%@: %@ %@\n", name, balance[@"amount"], balance[@"currency"]]];
            }
            self.balanceLabel.text = text;
        }
    }];
}

@end
