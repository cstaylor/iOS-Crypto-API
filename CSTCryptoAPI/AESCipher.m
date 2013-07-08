@interface AESCipher()
@property (nonatomic,strong) AESKey * key;
@property (nonatomic) enum CipherMode mode;
@property (nonatomic) int32_t status;
@property (nonatomic,getter=isValid) BOOL valid;
@property (nonatomic) CCCryptorRef cryptor;
@property (nonatomic, readonly) NSMutableData *buffer;
-(BOOL)isValid;
@end

@implementation AESCipher

-(BOOL)isValid
{
    return self.status == kCCSuccess;
}

-(id)init:(enum CipherMode)mode withKey:(id<SecretKey>)key
{
    return [self init:mode withKey:key iv:[NSData random:kCCBlockSizeAES128]];
}

-(id)init:(enum CipherMode)mode withKey:(id<SecretKey>)key iv:(NSData*)iv
{
    if ( self = [super init] ) {
        if ( !key ) self.mode = kCCParamError;
        else
            if ( [key isKindOfClass:[AESKey class]] )
            {
                self.key = (AESKey*)key;
                self.status = kCCSuccess;
                self.mode = mode;
                self.iv = !iv ? [NSData random:kCCBlockSizeAES128] : iv;
                self.cryptor = nil;
                self.status = CCCryptorCreate(mode == ENCRYPT ? kCCEncrypt : kCCDecrypt,
                                              kCCAlgorithmAES128,
                                              kCCOptionPKCS7Padding,
                                              [[key key] bytes],
                                              [[key key] length],
                                              self.iv.bytes,
                                              &_cryptor);
                if ( self.status == kCCSuccess ) _buffer = [NSMutableData data];
            }
            else
            {
                self.status = kCCParamError;
            }
    }
    return self;
}

- (void)dealloc
{
    if (_cryptor) {
        CCCryptorRelease(_cryptor);
        _cryptor = nil;
    }
}

-(NSData*)update:(NSData*)data onError:(NSError**)error
{
    __autoreleasing NSError * tempError;
    error = error == NULL ? &tempError : error;
    
    NSMutableData *buffer = self.buffer;
    [buffer setLength:CCCryptorGetOutputLength(self.cryptor, [data length], true)]; // We'll reuse the buffer in -finish
    
    size_t dataOutMoved;
    self.status = CCCryptorUpdate(self.cryptor,       // cryptor
                                  data.bytes,      // dataIn
                                  data.length,     // dataInLength (verified > 0 above)
                                  buffer.mutableBytes,      // dataOut
                                  buffer.length, // dataOutAvailable
                                  &dataOutMoved);   // dataOutMoved
    
    if (self.status != kCCSuccess) *error = [NSError errorWithDomain:@"world" code:self.status userInfo:nil];
        return self.status == kCCSuccess ? [buffer subdataWithRange:NSMakeRange(0, dataOutMoved)] : nil;
        }

-(NSData*)final:(NSError**)error
{
    __autoreleasing NSError * tempError;
    error = error == NULL ? &tempError : error;
    
    NSMutableData *buffer = self.buffer;
    size_t dataOutMoved;
    self.status = CCCryptorFinal(self.cryptor,
                                 buffer.mutableBytes,
                                 buffer.length,
                                 &dataOutMoved);
    if (self.status != kCCSuccess) *error = [NSError errorWithDomain:@"world" code:self.status userInfo:nil];
        return self.status == kCCSuccess ? [buffer subdataWithRange:NSMakeRange(0, dataOutMoved)] : nil;
        }


@end
