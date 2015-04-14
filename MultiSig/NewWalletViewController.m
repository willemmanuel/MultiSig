//
//  NewWalletViewController.m
//  MultiSig
//
//  Created by William Emmanuel on 4/12/15.
//  Copyright (c) 2015 William Emmanuel. All rights reserved.
//

#import "NewWalletViewController.h"
#import "CoinbaseSingleton.h"
#import <CoreBitcoin/CoreBitcoin.h>

@interface NewWalletViewController ()

@property (nonatomic, weak) IBOutlet UIButton* createNewWalletButton;
@property (nonatomic, weak) IBOutlet UITextField* walletNameField;
@property (nonatomic, weak) IBOutlet UITextField* userPublicKeyField;
@property (nonatomic, weak) IBOutlet UITextField* publicKeyTwoField;
@property (nonatomic, weak) IBOutlet UITextField* publicKeyThreeField;
@property (nonatomic, weak) IBOutlet UITextField* requiredSignaturesField;

@end

@implementation NewWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // example coinbase api call
    
//    [[CoinbaseSingleton shared].client doGet:@"accounts" parameters:nil completion:^(id result, NSError *error) {
//        if (error) {
//            NSLog(@"Could not load: %@", error);
//        } else {
//            NSArray *accounts = result[@"accounts"];
//            NSString *text = @"";
//            for (NSDictionary *account in accounts) {
//                NSString *name = account[@"name"];
//                NSDictionary *balance = account[@"balance"];
//                text = [text stringByAppendingString:[NSString stringWithFormat:@"%@: %@ %@\n", name, balance[@"amount"], balance[@"currency"]]];
//            }
//            self.balanceLabel.text = text;
//        }
//    }];
    

    self.userPublicKeyField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"public_key"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)newWalletButtonPressed:(id)sender
{
    NSArray *xPublicKeys = [NSArray arrayWithObjects:self.userPublicKeyField.text,self.publicKeyTwoField.text, self.publicKeyThreeField.text, nil];
    NSDictionary *account = [NSDictionary dictionaryWithObjectsAndKeys:self.walletNameField.text, @"name", @"multisig", @"type", self.requiredSignaturesField.text,@"m",xPublicKeys,@"xpubkeys", nil];
    NSDictionary *params = [NSDictionary dictionaryWithObject:account forKey:@"account"];
    [[CoinbaseSingleton shared].client doPost:@"accounts" parameters:params completion:^(id response, NSError *error) {
            NSLog(@"%@",response);
            NSLog(@"%@",error.localizedDescription);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end