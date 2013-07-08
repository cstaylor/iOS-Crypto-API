//
//  AESKeyWrapperTestCase.m
//  CSTCryptoAPI
//
//  Created by Christopher Taylor on 7/8/13.
//  Copyright (c) 2013 Christopher Taylor. All rights reserved.
//

#import "AESKeyWrapperTestCase.h"

@implementation AESKeyWrapperTestCase
-(void)testKeyWrapAndUnwrap
{
    NSError * error = nil;
    id<SecretKey> key = [[[AESKeyGenerator alloc] init] generate:128 onError:&error];
    
    id<KeySpec> keyspec = [[PBKDFKeySpec alloc] init:@"MyPassword"];
    id<SecretKeyFactory> factory = [[PBKDFSecretKeyFactory alloc] init];
    id<SecretKey> wrap_key = [factory generate:keyspec onError:&error];
    
    id<SecretKey> wrapped_key = [[[AESKeyWrapper alloc] init] wrap:key withKEK:wrap_key onError:&error];
    STAssertNil(error, @"Error should be nil" );
    
    id<SecretKey> unwrapped_key = [[[AESKeyUnwrapper alloc] init] unwrap:wrapped_key withKEK:wrap_key onError:&error];
    STAssertNil(error, @"Error should be nil" );
    STAssertEqualObjects([key key], [unwrapped_key key], @"They should have been equal");
}
@end
