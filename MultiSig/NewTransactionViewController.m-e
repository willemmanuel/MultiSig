//
//  NewTransactionViewController.m
//  MultiSig
//
//  Created by William Emmanuel on 4/12/15.
//  Copyright (c) 2015 William Emmanuel. All rights reserved.
//

#import "NewTransactionViewController.h"
#import "CoinbaseSingleton.h"

@interface NewTransactionViewController () {
    NSMutableArray *_multisigAccounts;
}

@end

@implementation NewTransactionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _multisigAccounts = [[NSMutableArray alloc] init];
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
    
    [[CoinbaseSingleton shared].client doDelete:@"transactions/552d83384692ab269c00013c" parameters:nil completion:^(id response, NSError *error) {
        NSLog(@"%@ \n %@", response, error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
