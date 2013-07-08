const NSInteger ILLEGAL_KEY_SIZE = 200;

@implementation AESKeyGenerator

-(id<SecretKey>)generate:(NSUInteger)keysize onError:(NSError**)error
{
    __autoreleasing NSError * tempError;
    error = error == NULL ? &tempError : error;
    int keysize_value = -1;
    switch ( keysize )
    {
        case 128: keysize_value = kCCKeySizeAES128; break;
        case 192: keysize_value = kCCKeySizeAES192; break;
        case 256: keysize_value = kCCKeySizeAES256; break;
    }
    
    id<SecretKey> ret_val = nil;
    
    NSData * symmetricKey = [NSData random:keysize_value];
    OSStatus err = SecRandomCopyBytes ( kSecRandomDefault, keysize_value, (uint8_t*)[symmetricKey bytes] );
    if ( err ) *error = [NSError errorWithDomain:@"world"
                                 code:ILLEGAL_KEY_SIZE
                                 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"Illegal keysize: %d",
                                                                                keysize ] } ];
    else {
        ret_val = [[AESKey alloc] init:symmetricKey keySize:keysize];
    }
    return ret_val;
}

@end
