#import "RSAKey+Private.h"

@interface RSAKey ()
+(NSMutableDictionary*)sharedDictionary:(NSString*)name for:(id)keyType;
@end

@implementation RSAKey
-(void)dealloc {
    if ( _key ) {
        CFRelease ( _key );
        _key = nil;
    }
}

+(BOOL)removeByName:(NSString*)name onError:(NSError**)error {
    __autoreleasing NSError * tempError;
    error = error == NULL ? &tempError : error;
    
    NSMutableDictionary *publicKey = [[NSMutableDictionary alloc] init];
    [publicKey setObject:b_kSecClassKey forKey:b_kSecClass];
    [publicKey setObject:b_kSecAttrKeyTypeRSA forKey:b_kSecAttrKeyType];
    [publicKey setObject:[RSAKey stringToTag:name] forKey:b_kSecAttrApplicationTag];
    OSStatus err = SecItemDelete((__bridge CFDictionaryRef)publicKey);
    if ( err ) *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:err userInfo:nil];
    return !err;
}

+(NSMutableDictionary*)sharedDictionary:(NSString*)name for:(id)keyType {
    NSMutableDictionary *publicKey = [[NSMutableDictionary alloc] init];
    [publicKey setObject:b_kSecClassKey forKey:b_kSecClass];
    [publicKey setObject:b_kSecAttrKeyTypeRSA forKey:b_kSecAttrKeyType];
    [publicKey setObject:[RSAKey stringToTag:name] forKey:b_kSecAttrApplicationTag];
    [publicKey setObject:keyType forKey:b_kSecAttrKeyClass];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:b_kSecReturnRef];
    return publicKey;
}

+(NSData*)stringToTag:(NSString*)string {
    const char * tag = [string UTF8String];
    NSData *d_tag = [NSData dataWithBytes:tag length:strlen(tag)];
    return d_tag;
}

+(NSData*)extractKeyFrom:(NSData*) data {
    unsigned char * bytes = (unsigned char *)[data bytes];
    size_t bytesLen = [data length];
    
    /* Strip the initial stuff */
    size_t i = 0;
    if (bytes[i++] != 0x30)
        return FALSE;
    
    /* Skip size bytes */
    if (bytes[i] > 0x80)
        i += bytes[i] - 0x80 + 1;
    else
        i++;
    
    if (i >= bytesLen)
        return FALSE;
    
    if (bytes[i] != 0x30)
        return FALSE;
    
    /* Skip OID */
    i += 15;
    
    if (i >= bytesLen - 2)
        return FALSE;
    
    if (bytes[i++] != 0x03)
        return FALSE;
    
    /* Skip length and null */
    if (bytes[i] > 0x80)
        i += bytes[i] - 0x80 + 1;
    else
        i++;
    
    if (i >= bytesLen)
        return FALSE;
    
    if (bytes[i++] != 0x00)
        return FALSE;
    
    if (i >= bytesLen)
        return FALSE;
    
    /* Here we go! */
    NSData * extractedKey = [NSData dataWithBytes:&bytes[i] length:bytesLen - i];
    return extractedKey;
}

-(id)initWithKey:(SecKeyRef)key {
    if ( self = [super init] ) {
        self.key = key;
    }
    return self;
}

+(NSMutableDictionary*)dictionaryForSearch:(NSString*)name for:(id)type {
    return [self sharedDictionary:name for:type];
}

+(NSMutableDictionary*)dictionaryForAdd:(NSString*)name for:(id)type value:(NSData*)value {
    NSMutableDictionary* ret_val = [self sharedDictionary:name for:type];
    [ret_val setObject:value forKey:b_kSecValueData];
    return ret_val;
}
@end
