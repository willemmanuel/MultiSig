//
//  ViewController.h
//  MultiSig
//
//  Created by William Emmanuel on 3/30/15.
//  Copyright (c) 2015 William Emmanuel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <coinbase-official/CoinbaseOAuth.h>
#import <coinbase-official/Coinbase.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) Coinbase* client;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

-(void) didFinishAuthentication;

@end

