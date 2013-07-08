//
//  AESKeyGeneratorTestCase.m
//  CSTCryptoAPI
//
//  Created by Christopher Taylor on 7/8/13.
//  Copyright (c) 2013 Christopher Taylor. All rights reserved.
//

#import "AESKeyGeneratorTestCase.h"

@implementation AESKeyGeneratorTestCase

-(void)testAESKeyGenerator
{
    NSError * error = nil;
    id<SecretKey> key = [[[AESKeyGenerator alloc] init] generate:128 onError:&error];
    STAssertNil(error, @"There shouldn't be any errors");
    STAssertNotNil(key, @"Key shouldn't be nil");
}

@end
