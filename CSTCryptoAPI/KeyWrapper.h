@protocol KeyWrapper <NSObject>
-(id<SecretKey>)wrap:(id<SecretKey>)raw withKEK:(id<SecretKey>)kek onError:(NSError**)error;
-(id<SecretKey>)wrap:(id<SecretKey>)raw withKEK:(id<SecretKey>)kek iv:(NSData*)iv onError:(NSError**)error;
@end

@protocol KeyUnwrapper <NSObject>
-(id<SecretKey>)unwrap:(id<SecretKey>)wrapped withKEK:(id<SecretKey>)kek onError:(NSError**)error;
-(id<SecretKey>)unwrap:(id<SecretKey>)wrapped withKEK:(id<SecretKey>)kek iv:(NSData*)iv onError:(NSError**)error;
@end
