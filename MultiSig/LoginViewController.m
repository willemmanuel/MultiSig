//
//  ViewController.m
//  MultiSig
//
//  Created by William Emmanuel on 3/30/15.
//  Copyright (c) 2015 William Emmanuel. All rights reserved.
//

#import "LoginViewController.h"
#import <coinbase-official/CoinbaseOAuth.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_loginButton addTarget:self action:@selector(didPressLogin) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)didPressLogin {
    [_loginButton setTitle:@"Logging in..." forState:UIControlStateNormal];
    [CoinbaseOAuth startOAuthAuthenticationWithClientId:@"api_id"
                                                  scope:@"user balance"
                                            redirectUri:@"edu.self.multisig.coinbase-oauth://coinbase-oauth"
                                                   meta:nil];
}

-(void) didFinishAuthentication:(Coinbase*)client {
    self.client = client;
    [self.client doGet:@"accounts" parameters:nil completion:^(id result, NSError *error) {
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
