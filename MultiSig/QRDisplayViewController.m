//
//  QRDisplayViewController.m
//  MultiSig
//
//  Created by William Emmanuel on 4/17/15.
//  Copyright (c) 2015 William Emmanuel. All rights reserved.
//

#import "QRDisplayViewController.h"
#import "CoinbaseSingleton.h"

@interface QRDisplayViewController ()

@end

@implementation QRDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_address == nil) {
        _qrImageView.image = [BTCQRCode imageForString:[CoinbaseSingleton shared].keychain.extendedPublicKey size:CGSizeMake(200, 200) scale:1.0];
        _addressLabel.text = [CoinbaseSingleton shared].keychain.extendedPublicKey;
    } else {
        _qrImageView.image = [BTCQRCode imageForString:_address size:CGSizeMake(200, 200) scale:1.0];
        _addressLabel.text = _address;
    }
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
