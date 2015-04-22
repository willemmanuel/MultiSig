//
//  SignTransactionViewController.m
//  MultiSig
//
//  Created by William Emmanuel on 4/12/15.
//  Copyright (c) 2015 William Emmanuel. All rights reserved.
//

#import "SignTransactionViewController.h"

@interface SignTransactionViewController ()

@end

@implementation SignTransactionViewController {
    NSString *_sighash;
    __block SignTransactionViewController *_ref;
    __block UIView *_qr;
    __block UIButton *_cancel;
    __block NSString *_scannedKey;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _ref = self;
    [_signButton addTarget:self action:@selector(signButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_qrButton addTarget:self action:@selector(didTapQrButton) forControlEvents:UIControlEventTouchUpInside];
    [_scanKeyButton addTarget:self action:@selector(didTapScanKeyButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIGestureRecognizer *dismissKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapToDismissKeyboard)];
    [self.view addGestureRecognizer:dismissKeyboard];
}

-(void)didTapToDismissKeyboard {
    [self.view endEditing:YES];
    [self resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didTapScanKeyButton {
    NSString *txid = _transactionId.text;
    if(txid == nil) {
        [self badTransactionId];
        return;
    }
    _qr = [BTCQRCode scannerViewWithBlock:^(NSString *message) {
        [_ref didReturnFromKeyScanQr:message];
    }];
    _cancel = [[UIButton alloc] initWithFrame:CGRectMake(10, 80, 50, 50)];
    [_cancel addTarget:self action:@selector(didCancelQr) forControlEvents:UIControlEventTouchUpInside];
    [_cancel setTitle:@"X" forState:UIControlStateNormal];
    [_cancel setBackgroundColor:[UIColor whiteColor]];
    [_cancel setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:_qr];
    [_qr addSubview:_cancel];
}

-(void)didTapQrButton {
    _qr = [BTCQRCode scannerViewWithBlock:^(NSString *message) {
        [_ref didReturnFromQr:message];
    }];
    _cancel = [[UIButton alloc] initWithFrame:CGRectMake(10, 80, 50, 50)];
    [_cancel addTarget:self action:@selector(didCancelQr) forControlEvents:UIControlEventTouchUpInside];
    [_cancel setTitle:@"X" forState:UIControlStateNormal];
    [_cancel setBackgroundColor:[UIColor whiteColor]];
    [_cancel setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:_qr];
    [_qr addSubview:_cancel];
}

-(void)didReturnFromKeyScanQr:(NSString*)message {
    _scannedKey = message;
    [_qr removeFromSuperview];
    [self signButtonPressed];
}

-(void)didCancelQr {
    [_cancel removeFromSuperview];
    [_qr removeFromSuperview];
}

-(void)didReturnFromQr:(NSString*)code {
    _transactionId.text = code;
    [_qr removeFromSuperview];
}

-(void)signButtonPressed {
    NSString *txid = _transactionId.text;
    if(txid == nil) {
        [self badTransactionId];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"transactions/%@/sighashes", txid];
    [[CoinbaseSingleton shared].client doGet:url parameters:nil completion:^(id result, NSError *error) {
        if (error)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                           message:error.localizedDescription
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
        //response[transaction][inputs] first [sighash]
        // get through the mess of a response from coinbase
        NSDictionary *transaction = result[@"transaction"];
        NSDictionary *input = [transaction[@"inputs"] firstObject];
        input = input[@"input"];
        NSLog(@"%@", input);
        NSString *nodePath = [input[@"address"][@"addresses"] firstObject][@"address"][@"node_path"];
        nodePath = [nodePath stringByReplacingOccurrencesOfString:@"m/" withString:@""];
        [self didFinishFetchingTx:txid sighash:input[@"sighash"] nodePath:[nodePath intValue]];
    }];
}

-(void) didFinishFetchingTx:(NSString*)tx sighash:(NSString*)sighash nodePath:(int)nodePath{
    //[address][addresses] firstObject [address] "node_path"
    NSArray *sigArray;
    if(_scannedKey != nil) {
        BTCKeychain *keychain2 = [[BTCKeychain alloc] initWithExtendedKey:_scannedKey];
         sigArray = [[NSArray alloc] initWithObjects:[self signHash:sighash withKey:[keychain2 keyAtIndex:nodePath]],nil];
        _scannedKey = nil; 
    } else {
        sigArray = [[NSArray alloc] initWithObjects:[self signHash:sighash withKey:[[CoinbaseSingleton shared].keychain keyAtIndex:nodePath]],nil];
    }
    NSString *putUrl = [NSString stringWithFormat:@"transactions/%@/signatures", tx];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"signatures"] = [[NSMutableArray alloc] init];
    [params[@"signatures"] addObject:[NSMutableDictionary new]];
    NSMutableDictionary* test = (NSMutableDictionary*)[params[@"signatures"] firstObject];
    test[@"position"] = @1;
    test[@"signatures"] = sigArray;
    [[CoinbaseSingleton shared].client doPut:putUrl parameters:params completion:^(id result, NSError *error) {
        NSLog(@"%@", result);
        NSLog(@"%@", error);
    }];
}

#pragma mark - Helpers

-(NSString*) signHash:(NSString*)hash withKey:(BTCKey*)key {
    return [self convertDataToHexString:[key signatureForHash:[self convertHexStringToData:hash]]];
}

-(NSString*) convertDataToHexString:(NSData*) data {
    NSUInteger capacity = data.length * 2;
    NSMutableString *sbuf = [NSMutableString stringWithCapacity:capacity];
    const unsigned char *buf = data.bytes;
    NSInteger i;
    for (i=0; i<data.length; ++i) {
        [sbuf appendFormat:@"%02X", (NSUInteger)buf[i]];
    }
    return [sbuf lowercaseString];
}

-(NSData*) convertHexStringToData:(NSString*)command {
    NSMutableData *commandToSend= [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [command length]/2; i++) {
        byte_chars[0] = [command characterAtIndex:i*2];
        byte_chars[1] = [command characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [commandToSend appendBytes:&whole_byte length:1];
    }
    return commandToSend;
}

#pragma mark - Alerts

-(void)badTransactionId {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty TX" message:@"You cannot sign an empty transaction" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
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
