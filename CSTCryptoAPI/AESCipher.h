@interface AESCipher : NSObject<Cipher>
-(id)init:(enum CipherMode)mode withKey:(id<SecretKey>)key;
-(id)init:(enum CipherMode)mode withKey:(id<SecretKey>)key iv:(NSData*)iv;
@property (nonatomic,strong) NSData * iv;
@property (nonatomic,readonly) BOOL valid;
@end