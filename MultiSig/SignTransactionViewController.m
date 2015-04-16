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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_signButton addTarget:self action:@selector(signButtonPressed) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)signButtonPressed {
//    NSString *txid = _transactionId.text;
    NSString *txid = @"552f2ad8f7c24ec7800000d6";
    if(txid == nil) {
        [self badTransactionId];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"transactions/%@/sighashes", txid];
    [[CoinbaseSingleton shared].client doGet:url parameters:nil completion:^(id result, NSError *error) {
        //response[transaction][inputs] first [sighash]
        // get through the mess of a response from coinbase
        NSDictionary *transaction = result[@"transaction"];
        NSDictionary *input = [transaction[@"inputs"] firstObject];
        input = input[@"input"];
        [self didFinishFetchingTx:txid sighash:input[@"sighash"]];
    }];
}

-(void) didFinishFetchingTx:(NSString*)tx sighash:(NSString*)sighash {
    BTCKeychain *keychain1 = [[BTCKeychain alloc] initWithExtendedKey:@"xprv9s21ZrQH143K2n2gevYdgEb1bTzWiqjc6g2ovJSVEaK794ZTBDkGKs839AT7VUnAw6d6UfokDo4g98MrhoKdhgefTB8GzaQUZ53xw6Shmd4"];
    BTCKeychain *keychain2 = [[BTCKeychain alloc] initWithExtendedKey:@"xprv9s21ZrQH143K3MrTYjdPt8zbgE6YVVfjrv4hJE3wLv3oGHG4Liv4kP1PE97gGbCPeHPoBB11HySK9N1VPuChb3LJuiP7NptoUyB9XCVfgFK"];
    
    NSString *putUrl = [NSString stringWithFormat:@"transactions/%@/signatures", tx];
    
    NSArray *sigArray = [[NSArray alloc] initWithObjects:[self signHash:sighash withKey:[keychain1 keyAtIndex:0]], [self signHash:sighash withKey:[keychain2 keyAtIndex:0]],nil];
    NSLog(@"sigs: %@", sigArray);
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
