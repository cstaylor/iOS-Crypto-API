/* Code adapted from several places:
 *   http://blog.flirble.org/2011/01/05/rsa-public-key-openssl-ios/
 *   http://blog.wingsofhermes.org/?p=75
 */

#import "RSAKey+Private.h"

@implementation RSAPublicKey
+(RSAPublicKey*)findByName:(NSString*)name onError:(NSError**)error {
    
    __autoreleasing NSError * tempError;
    error = error == NULL ? &tempError : error;
    
    RSAPublicKey* ret_val = nil;
    SecKeyRef keyRef = nil;
    
    NSMutableDictionary *publicKey = [super dictionaryForSearch:name for:b_kSecAttrKeyClassPublic];
    OSStatus secStatus = SecItemCopyMatching((__bridge CFDictionaryRef)publicKey,
                                             (CFTypeRef *)&keyRef);
    if ( secStatus ) *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:secStatus userInfo:nil];
    else if ( keyRef != nil) ret_val = [[RSAPublicKey alloc] initWithKey:keyRef];
    return ret_val;
}

-(id)initWithBase64:(NSString*)pem name:(NSString*)name onError:(NSError**)error {
    NSData * rawBytes = [pem strip:@"PUBLIC KEY"];
    if ( rawBytes ) {
        self = [self initWithBytes:rawBytes name:name onError:error];
    }
    return self;
}

-(id)initWithBytes:(NSData*)rawBytes name:(NSString*)name onError:(NSError**)error {
    __autoreleasing NSError * tempError;
    error = error == NULL ? &tempError : error;
    
    if ( self = [super init] ) {
        NSData * extractedKey = [RSAPublicKey extractKeyFrom:rawBytes];
        NSMutableDictionary *keyAttr = [RSAKey dictionaryForAdd:name for:b_kSecAttrKeyClassPublic value:extractedKey];
        SecKeyRef key = nil;
        OSStatus secStatus = SecItemAdd((__bridge CFDictionaryRef) keyAttr, (CFTypeRef *)&key);
        if ( secStatus ) *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:secStatus userInfo:nil];
        else self.key = key;
    }
    return self;
}

-(NSData*)encrypt:(NSData*)plaintext onError:(NSError**)error {
    __autoreleasing NSError * tempError;
    error = error == NULL ? &tempError : error;
    
    NSData * ret_val = nil;
    size_t cipher_text_size = SecKeyGetBlockSize( self.key );
    uint8_t * cipher_text = malloc ( cipher_text_size );
    memset ( cipher_text, 0x0, cipher_text_size );
    OSStatus secStatus = SecKeyEncrypt( self.key,
                                       kSecPaddingPKCS1,
                                       [plaintext bytes],
                                       [plaintext length],
                                       cipher_text,
                                       &cipher_text_size );
    if ( secStatus ) *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:secStatus userInfo:nil];
    else ret_val = [NSData dataWithBytes:cipher_text length:cipher_text_size];
    free ( cipher_text );
    return ret_val;
}

@end
