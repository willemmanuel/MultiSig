//
//  CoinbaseAPIClient.m
//  MultiSig
//
//  Created by William Emmanuel on 4/6/15.
//  Copyright (c) 2015 William Emmanuel. All rights reserved.
//

#import "CoinbaseSingleton.h"

@implementation CoinbaseSingleton

# pragma mark singleton methods

+ (CoinbaseSingleton*)shared {
    static CoinbaseSingleton *sharedCoinbaseSingleton = nil;
    @synchronized(self) {
        if (sharedCoinbaseSingleton == nil)
            sharedCoinbaseSingleton = [[self alloc] init];
    }
    return sharedCoinbaseSingleton;
}

- (id)init {
    if (self = [super init]) {
        _client = nil;
    }
    return self;
}

-(BOOL)authenticated {
    if(_client == nil) {
        return NO;
    } else {
        return YES;
    }
}

- (void)dealloc {
    
}

@end
