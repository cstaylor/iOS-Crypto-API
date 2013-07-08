#define SALT_SIZE 8
#define DEFAULT_ROUNDS 10000
#define DEFAULT_KEYSIZE kCCKeySizeAES128

@implementation PBKDFKeySpec

-(id)init:(NSString*)password
{
    return [self init:password salt:[NSData random:SALT_SIZE] ];
}

-(id)init:(NSString*)password salt:(NSData*)salt
{
    return [self init:password salt:salt rounds:DEFAULT_ROUNDS ];
}

-(id)init:(NSString*)password salt:(NSData*)salt rounds:(uint)rounds
{
    if ( self = [super init] ) {
        self.password = password;
        self.salt = salt;
        self.rounds = rounds;
    }
    return self;
}
@end

@implementation PBKDFSecretKeyFactory
-(id<SecretKey>)generate:(id<KeySpec>)spec onError:(NSError**)error
{
    __autoreleasing NSError * tempError;
    error = error == NULL ? &tempError : error;
    
    id<SecretKey> ret_val = nil;
    
    if ( [spec isKindOfClass:[PBKDFKeySpec class]] ) {
        PBKDFKeySpec* pbk_spec = (PBKDFKeySpec*)spec;
        OSStatus result = 0;
        NSMutableData *derivedKey = [NSMutableData dataWithLength:DEFAULT_KEYSIZE];
        result = CCKeyDerivationPBKDF(kCCPBKDF2,
                                      pbk_spec.password.UTF8String,
                                      pbk_spec.password.length,
                                      pbk_spec.salt.bytes,
                                      pbk_spec.salt.length,
                                      kCCPRFHmacAlgSHA1,
                                      pbk_spec.rounds,
                                      derivedKey.mutableBytes,
                                      derivedKey.length);
        if ( result ) *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:result userInfo:nil];
        else ret_val = [[AESKey alloc] init:derivedKey keySize:DEFAULT_KEYSIZE];
    }
    return ret_val;
}
@end
