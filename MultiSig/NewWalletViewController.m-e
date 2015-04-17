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
#import <SSKeychain/SSKeychain.h>

@interface NewWalletViewController ()

@property (nonatomic, weak) IBOutlet UIButton* createNewWalletButton;
@property (nonatomic, weak) IBOutlet UIButton* logoutButton;
@property (nonatomic, weak) IBOutlet UITextField* walletNameField;
@property (nonatomic, weak) IBOutlet UITextField* userPublicKeyField;
@property (nonatomic, weak) IBOutlet UITextField* publicKeyTwoField;
@property (nonatomic, weak) IBOutlet UITextField* publicKeyThreeField;
@property (nonatomic, weak) IBOutlet UITextField* requiredSignaturesField;
@property (weak, nonatomic) IBOutlet UIButton *qrButton2;
@property (weak, nonatomic) IBOutlet UIButton *qrButton3;

@end

@implementation NewWalletViewController {
    __block NewWalletViewController *_ref;
    __block UIView *_qr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _ref = self;
    UIGestureRecognizer *dismissKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapToDismissKeyboard)];
    [self.view addGestureRecognizer:dismissKeyboard];
    NSString *user_id = [[NSUserDefaults standardUserDefaults] stringForKey:@"user_id"];
    self.userPublicKeyField.text = [SSKeychain passwordForService:@"extended_public_key" account:user_id];
    
    [_qrButton2 addTarget:self action:@selector(didTapQrButton:) forControlEvents:UIControlEventTouchUpInside];
    [_qrButton3 addTarget:self action:@selector(didTapQrButton:) forControlEvents:UIControlEventTouchUpInside];
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
        UIAlertController *alert;
        if (error)
        {
            NSLog(@"%@",error);
            alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            
        }
        else
        {
            NSString *account_id = response[@"account"][@"id"];
            alert = [UIAlertController alertControllerWithTitle:@"Success" message:@"New wallet successfully created!" preferredStyle:UIAlertControllerStyleAlert];
            [[NSUserDefaults standardUserDefaults] setObject:account_id forKey:@"wallet"];
        }
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Ok", @"Ok action")
                                       style:UIAlertActionStyleCancel
                                       handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }];
}
-(void)didTapToDismissKeyboard {
    [self.view endEditing:YES];
    [self resignFirstResponder];
}

-(void)didTapQrButton:(id)sender {
    if (sender == _qrButton2) {
        _qr = [BTCQRCode scannerViewWithBlock:^(NSString *message) {
            [_ref didReturnFromQr:message andPubKey:2];
        }];
    } else if (sender == _qrButton3) {
        _qr = [BTCQRCode scannerViewWithBlock:^(NSString *message) {
            [_ref didReturnFromQr:message andPubKey:3];
        }];
    }
    [self.view addSubview:_qr];
}

-(void)didReturnFromQr:(NSString*)code andPubKey:(int)pub {
    [_qr removeFromSuperview];
    if(pub == 2) {
        _publicKeyTwoField.text = code;
    } else if (pub == 3) {
        _publicKeyThreeField.text = code; 
    }
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
