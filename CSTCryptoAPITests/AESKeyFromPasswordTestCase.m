//
//  AESKeyFromPasswordTestCase.m
//  CSTCryptoAPI
//
//  Created by Christopher Taylor on 7/8/13.
//  Copyright (c) 2013 Christopher Taylor. All rights reserved.
//

#import "AESKeyFromPasswordTestCase.h"

@implementation AESKeyFromPasswordTestCase
-(void)testGeneratingKeyFromPassword
{
    NSError * error = nil;
    id<KeySpec> keyspec = [[PBKDFKeySpec alloc] init:@"MyPassword"];
    id<SecretKeyFactory> factory = [[PBKDFSecretKeyFactory alloc] init];
    id<SecretKey> key = [factory generate:keyspec onError:&error];
    STAssertNil(error, @"There shouldn't be any errors");
    STAssertNotNil(key, @"Key shouldn't be nil");
}
@end
