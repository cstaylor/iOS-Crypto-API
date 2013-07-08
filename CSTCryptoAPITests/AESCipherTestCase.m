//
//  AESCipherTestCase.m
//  CSTCryptoAPI
//
//  Created by Christopher Taylor on 7/8/13.
//  Copyright (c) 2013 Christopher Taylor. All rights reserved.
//

#import "AESCipherTestCase.h"

@implementation AESCipherTestCase
-(void)testCipher
{
    NSData * random_blob = [NSData random:4096];
    STAssertNotNil(random_blob, @"random_blob shouldn't be nil");
    
    NSError * error = nil;
    id<SecretKey> key = [[[AESKeyGenerator alloc] init] generate:128 onError:&error];
    STAssertNil(error, @"There shouldn't be any errors");
    STAssertNotNil(key, @"Key shouldn't be nil");
    
    id<Cipher> cipher = [[AESCipher alloc] init:ENCRYPT withKey:key];
    STAssertNotNil(cipher, @"cipher shouldn't be nil");
    
    NSMutableData * output = [NSMutableData data];
    [output appendData:[cipher update:random_blob onError:&error]];
    STAssertNil(error, @"There shouldn't be any errors");

    [output appendData:[cipher final:&error]];
    STAssertNil(error, @"There shouldn't be any errors");
}
@end
