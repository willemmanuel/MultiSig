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
    __block NewTransactionViewController *_ref;
    __block UIView *_qr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _ref = self;
    UIGestureRecognizer *dismissKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapToDismissKeyboard)];
    [self.view addGestureRecognizer:dismissKeyboard];
    
    [_createTxButton addTarget:self action:@selector(didTapCreateButton) forControlEvents:UIControlEventTouchUpInside];
    [_qrButton addTarget:self action:@selector(didTapQrButton) forControlEvents:UIControlEventTouchUpInside];
    
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
}

-(void)didTapQrButton {
    _qr = [BTCQRCode scannerViewWithBlock:^(NSString *message) {
        [_ref didReturnFromQr:message];
    }];
    [self.view addSubview:_qr];
}

-(void)didReturnFromQr:(NSString*)code {
    code = [code stringByReplacingOccurrencesOfString:@"bitcoin:" withString:@""];
    _to.text = code;
    [_qr removeFromSuperview];
}

-(void)didTapCreateButton {
    if (! [self validData] ) return;
    
    NSDictionary *params = @{@"transaction":@{@"to":_to.text, @"amount":_amount.text}, @"account_id":_currentlySelectedAccount[@"id"]};

    [[CoinbaseSingleton shared].client doPost:@"transactions/send_money" parameters:params completion:^(id response, NSError *error) {
        NSLog(@"%@, %@", response, error);
        NSDictionary *transaction = response[@"transaction"];
        NSString *txid = transaction[@"id"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TX Posted" message:txid delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

-(BOOL) validData {
    if(_to.text == nil || _amount.text == nil || _accountID.text == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Data" message:@"Please fill out all transaction information" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    return YES;
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
