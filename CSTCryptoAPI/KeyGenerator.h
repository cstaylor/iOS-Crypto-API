@protocol KeyGenerator <NSObject>
-(id<SecretKey>)generate:(NSUInteger)keysize onError:(NSError**)error;
@end