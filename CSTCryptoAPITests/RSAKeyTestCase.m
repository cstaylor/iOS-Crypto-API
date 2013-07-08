#import "RSAKeyTestCase.h"

@implementation RSAKeyTestCase
-(void)testRSAKeys
{
    NSString * PEM_DATA = [NSString stringWithFormat:@"-----BEGIN PUBLIC KEY-----\n"
                           @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnx9iZDQOcnsu8dNQx4k8+7dy2\n"
                           @"xpMXog5BhZVsNW0o+qGiLpYorRJ9elks38IIHBrX6ilwkQo74qUMAst8TqJBCloA\n"
                           @"N8CCy6hj5jIwFMtzKggtt2K0AXVzX9TAfa8nBpBWaz/8szeE4Nycfsplbubqf6ts\n"
                           @"01oicKUFaS/KZxvpvQIDAQAB\n"
                           @"-----END PUBLIC KEY-----"];
    
    NSError * error = nil;
    RSAPublicKey * rsa = [RSAPublicKey findByName:@"server" onError:&error];
    if ( !rsa ) {
        error = nil;
        rsa = [[RSAPublicKey alloc] initWithBase64:PEM_DATA name:@"server" onError:&error ];
    }
    STAssertNotNil( rsa, @"RSA Key shouldn't be nil" );
    STAssertNil(error, @"Error should be nil" );
    id<SecretKey> key = [[[AESKeyGenerator alloc] init] generate:128 onError:&error];
    STAssertNotNil( key, @"AESKey shouldn't be nil" );
    STAssertNil(error, @"Error should be nil" );
    NSData * blob = [rsa encrypt:[key key] onError:&error];
    STAssertNotNil( blob, @"Encrypted data shouldn't be nil" );
    STAssertNil(error, @"Error should be nil" );
}
@end
