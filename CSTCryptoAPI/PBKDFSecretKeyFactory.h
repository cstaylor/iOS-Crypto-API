#import <Foundation/Foundation.h>
#import "SecretKeyFactory.h"

@interface PBKDFKeySpec : NSObject<KeySpec>
-(id)init:(NSString*)password;
-(id)init:(NSString*)password salt:(NSData*)salt;
-(id)init:(NSString*)password salt:(NSData*)salt rounds:(uint)rounds;
@property (nonatomic,strong) NSString * password;
@property (nonatomic,strong) NSData * salt;
@property (nonatomic) uint rounds;
@end

@interface PBKDFSecretKeyFactory : NSObject<SecretKeyFactory>

@end