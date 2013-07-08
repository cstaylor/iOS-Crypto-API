@interface RSAKey : NSObject
+(BOOL)removeByName:(NSString*)name onError:(NSError**)error;
@end

@interface RSAPublicKey : RSAKey
+(RSAPublicKey*)findByName:(NSString*)name onError:(NSError**)error;
-(id)initWithBytes:(NSData*)rawBytes name:(NSString*)name onError:(NSError**)error;
-(id)initWithBase64:(NSString*)pem name:(NSString*)name onError:(NSError**)error;
-(NSData*)encrypt:(NSData*)plaintext onError:(NSError**)error;
@end