//
//  AESKeyWrapper.m
//  CSTCryptoAPI
//
//  Created by Christopher Taylor on 7/8/13.
//  Copyright (c) 2013 Christopher Taylor. All rights reserved.
//

@implementation AESKeyWrapper

-(id<SecretKey>)wrap:(id<SecretKey>)raw withKEK:(id<SecretKey>)kek onError:(NSError**)error
{
    return [self wrap:raw
              withKEK:kek
                   iv:[NSData dataWithBytesNoCopy:(void*)CCrfc3394_iv length:CCrfc3394_ivLen freeWhenDone:NO]
              onError:error];
}

-(id<SecretKey>)wrap:(id<SecretKey>)raw withKEK:(id<SecretKey>)kek iv:(NSData*)iv onError:(NSError**)error
{
    __autoreleasing NSError * tempError;
    error = error == NULL ? &tempError : error;
    
    id<SecretKey> wrapped_key = nil;
    
    if ( !raw ) *error = [NSError errorWithDomain:@"world" code:200 userInfo:nil];
    else if ( !kek ) *error = [NSError errorWithDomain:@"world" code:201 userInfo:nil];
    else if ( ![raw isKindOfClass:[AESKey class] ] ) *error = [NSError errorWithDomain:@"world" code:202 userInfo:nil];
    else if ( ![kek isKindOfClass:[AESKey class] ] ) *error = [NSError errorWithDomain:@"world" code:203 userInfo:nil];
    else {
        NSData * raw_bytes = [raw key];
        NSData * kek_bytes = [kek key];
        size_t wrapped_buffer_size = CCSymmetricWrappedSize ( kCCWRAPAES, [raw_bytes length] );
        uint8_t  * wrapped_buffer = malloc( wrapped_buffer_size );
        memset ( wrapped_buffer, 0x0, wrapped_buffer_size );
        int status = CCSymmetricKeyWrap ( kCCWRAPAES,
                                          [iv bytes],
                                          [iv length],
                                          [kek_bytes bytes],
                                          [kek_bytes length],
                                          [raw_bytes bytes],
                                          [raw_bytes length],
                                          wrapped_buffer,
                                          &wrapped_buffer_size );
        if ( status != kCCSuccess ) *error = [NSError errorWithDomain:@"world" code:204 userInfo:nil];
        else wrapped_key = [[AESKey alloc] init:[NSData dataWithBytes:wrapped_buffer length:wrapped_buffer_size]
                                           keySize:128];
        free ( wrapped_buffer );
    }
    return wrapped_key;
}

@end

@implementation AESKeyUnwrapper

-(id<SecretKey>)unwrap:(id<SecretKey>)wrapped withKEK:(id<SecretKey>)kek onError:(NSError**)error
{
    return [self unwrap:wrapped
                withKEK:kek
                     iv:[NSData dataWithBytesNoCopy:(void*)CCrfc3394_iv length:CCrfc3394_ivLen freeWhenDone:NO]
                onError:error];
}

-(id<SecretKey>)unwrap:(id<SecretKey>)wrapped withKEK:(id<SecretKey>)kek iv:(NSData*)iv onError:(NSError**)error
{
    __autoreleasing NSError * tempError;
    error = error == NULL ? &tempError : error;
    
    id<SecretKey> raw_key = nil;
    
    if ( !wrapped ) *error = [NSError errorWithDomain:@"world" code:200 userInfo:nil];
    else if ( !kek ) *error = [NSError errorWithDomain:@"world" code:201 userInfo:nil];
    else if ( ![wrapped isKindOfClass:[AESKey class] ] ) *error = [NSError errorWithDomain:@"world" code:202 userInfo:nil];
    else if ( ![kek isKindOfClass:[AESKey class] ] ) *error = [NSError errorWithDomain:@"world" code:203 userInfo:nil];
    else {
        NSData * wrapped_bytes = [wrapped key];
        NSData * kek_bytes = [kek key];
        size_t unwrapped_buffer_size = CCSymmetricUnwrappedSize ( kCCWRAPAES, [wrapped_bytes length] );
        uint8_t  * unwrapped_buffer = malloc( unwrapped_buffer_size );
        memset ( unwrapped_buffer, 0x0, unwrapped_buffer_size );
        int status = CCSymmetricKeyUnwrap ( kCCWRAPAES,
                                            [iv bytes],
                                            [iv length],
                                            [kek_bytes bytes],
                                            [kek_bytes length],
                                            [wrapped_bytes bytes],
                                            [wrapped_bytes length],
                                            unwrapped_buffer,
                                            &unwrapped_buffer_size );
        if ( status != kCCSuccess ) *error = [NSError errorWithDomain:@"world" code:204 userInfo:nil];
        else raw_key = [[AESKey alloc] init:[NSData dataWithBytes:unwrapped_buffer length:unwrapped_buffer_size]
                                       keySize:128];
        free ( unwrapped_buffer );
    }
    return raw_key;
}

@end
