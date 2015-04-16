//
//  NewTransactionViewController.m
//  MultiSig
//
//  Created by William Emmanuel on 4/12/15.
//  Copyright (c) 2015 William Emmanuel. All rights reserved.
//

#import "NewTransactionViewController.h"
#import "CoinbaseSingleton.h"

@interface NewTransactionViewController ()

@end

@implementation NewTransactionViewController {
    UIPickerView *_accountPicker;
    NSMutableArray *_multisigAccounts;
    NSDictionary *_currentlySelectedAccount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIGestureRecognizer *dismissKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapToDismissKeyboard)];
    [self.view addGestureRecognizer:dismissKeyboard];
    
    _multisigAccounts = [[NSMutableArray alloc] init];
    _accountPicker  = [[UIPickerView alloc] init];
    _accountPicker.delegate = self;
    _accountPicker.dataSource = self;
    _accountPicker.showsSelectionIndicator = YES;
    _accountID.inputView = _accountPicker;
    
    _accountID.returnKeyType = UIReturnKeyDone;
    _amount.returnKeyType = UIReturnKeyDone;
    _to.returnKeyType = UIReturnKeyDone;
    
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
    // 552d7d15d77bbf5f790000e7
    
    // NEW TX CODE BELOW
//    NSDictionary *params = @{@"transaction":@{@"to":@"15KdoHLtou7FP2foEHrtps5TsVZEEB3n4V", @"amount":@"0.0001"}, @"account_id":@"552d7d15d77bbf5f790000e7"};
//    
//    NSLog(@"%@", params); 
//    [[CoinbaseSingleton shared].client doPost:@"transactions/send_money" parameters:params completion:^(id response, NSError *error) {
//        NSLog(@"%@, %@", response, error);
//        NSDictionary *transaction = response[@"transaction"];
//        NSString *txid = transaction[@"id"];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TX Posted" message:txid delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didTapToDismissKeyboard {
    [self.view endEditing:YES];
    [self resignFirstResponder];
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
    _accountID.text = _currentlySelectedAccount[@"name"];
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
