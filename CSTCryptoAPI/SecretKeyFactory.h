// Just a tagging protocol
@protocol KeySpec <NSObject>

@end

@protocol SecretKeyFactory <NSObject>
-(id<SecretKey>)generate:(id<KeySpec>)spec onError:(NSError**)error;
@end