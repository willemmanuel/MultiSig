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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _ref = self;
    [_signButton addTarget:self action:@selector(signButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_qrButton addTarget:self action:@selector(didTapQrButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Targets

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
        [self didFinishFetchingTx:txid sighash:input[@"sighash"]];
        }
    }];
}

-(void) didFinishFetchingTx:(NSString*)tx sighash:(NSString*)sighash {
    BTCKeychain *keychain2 = [[BTCKeychain alloc] initWithExtendedKey:@"xprv9s21ZrQH143K3MrTYjdPt8zbgE6YVVfjrv4hJE3wLv3oGHG4Liv4kP1PE97gGbCPeHPoBB11HySK9N1VPuChb3LJuiP7NptoUyB9XCVfgFK"];
    NSString *putUrl = [NSString stringWithFormat:@"transactions/%@/signatures", tx];
    NSArray *sigArray = [[NSArray alloc] initWithObjects:[self signHash:sighash withKey:[keychain2 keyAtIndex:1]],nil];
    //NSArray *sigArray = [[NSArray alloc] initWithObjects:[self signHash:sighash withKey:[[CoinbaseSingleton shared].keychain keyAtIndex:0]],nil];
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
