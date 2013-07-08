#import "RSAKey.h"

@interface RSAKey ()
@property (nonatomic) SecKeyRef key;
+(NSData*)extractKeyFrom:(NSData*) bytes;
+(NSData*)stringToTag:(NSString*)string;
-(id)initWithKey:(SecKeyRef)key;
+(NSMutableDictionary*)dictionaryForSearch:(NSString*)name for:(id)keyType;
+(NSMutableDictionary*)dictionaryForAdd:(NSString*)name for:(id)keyType value:(NSData*)data;
@end
