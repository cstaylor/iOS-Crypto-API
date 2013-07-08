@interface AESKey : NSObject<SecretKey>
-(id)init:(NSData*)data keySize:(NSUInteger)size;
@property (nonatomic,copy) NSData* keyData;
@property (nonatomic) NSUInteger size;
@end
