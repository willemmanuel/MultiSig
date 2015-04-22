//
//  PickAccountViewController.m
//  MultiSig
//
//  Created by William Emmanuel on 4/19/15.
//  Copyright (c) 2015 William Emmanuel. All rights reserved.
//

#import "PickWalletViewController.h"
#import "CoinbaseSingleton.h"
#import "QRDisplayViewController.h"
@interface PickWalletViewController ()

@end

@implementation PickWalletViewController {
    UIPickerView *_walletPicker;
    NSMutableArray *_multisigAccounts;
    NSDictionary *_currentlySelectedAccount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIGestureRecognizer *dismissKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapToDismissKeyboard)];
    [self.view addGestureRecognizer:dismissKeyboard];
    
    [_getAddressButton addTarget:self action:@selector(didTapGetAddressButton) forControlEvents:UIControlEventTouchUpInside];
    _multisigAccounts = [[NSMutableArray alloc] init];
    _walletPicker  = [[UIPickerView alloc] init];
    _walletPicker.delegate = self;
    _walletPicker.dataSource = self;
    _walletPicker.showsSelectionIndicator = YES;
    _walletId.inputView = _walletPicker;
    
    _walletId.returnKeyType = UIReturnKeyDone;
    
    [[CoinbaseSingleton shared].client doGet:@"accounts" parameters:nil completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"Could not load: %@", error);
        } else {
            NSArray *accounts = result[@"accounts"];
            for (NSDictionary *account in accounts) {
                if ([account[@"type"] isEqualToString:@"multisig"])
                    [_multisigAccounts addObject:account];
            }
            NSLog(@"%@", _multisigAccounts);
        }
    }];
}

-(void)didTapToDismissKeyboard {
    [self.view endEditing:YES];
    [self resignFirstResponder];
}

-(void)didTapGetAddressButton {
    NSDictionary *params = @{@"account_id": _currentlySelectedAccount[@"id"]};
    [[CoinbaseSingleton shared].client doGet:@"addresses" parameters:params completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"Could not load: %@", error);
        } else {
           NSString *address = [result[@"addresses"] firstObject][@"address"][@"address"];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            QRDisplayViewController *qrvc = (QRDisplayViewController*)[storyboard instantiateViewControllerWithIdentifier:@"QRViewController"];
            qrvc.address = address;
            [self.navigationController pushViewController:qrvc animated:YES];
        }
    }];
}

# pragma mark - UIPickerView methods

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_multisigAccounts count];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSDictionary *account = [_multisigAccounts objectAtIndex:row];
    return account[@"name"];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _currentlySelectedAccount = [_multisigAccounts objectAtIndex:row];
    _walletId.text = _currentlySelectedAccount[@"name"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
