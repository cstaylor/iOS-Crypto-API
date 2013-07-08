#import "StreamTestCase.h"
#import "NSFileManager+iOS.h"

@implementation StreamTestCase
-(void)testStreaming
{
    NSData * random = [NSData random:4096];
    NSFileManager * fm = [NSFileManager defaultManager];
    NSError * error = nil;
    
    NSString * plaintext = [fm fileInDocuments:@"test.plaintext" onError:&error];
    STAssertNil(error, @"There shouldn't be any errors" );
    NSString * ciphertext = [fm fileInDocuments:@"test.ciphertext" onError:&error];
    STAssertNil(error, @"There shouldn't be any errors" );
    
    [random writeToFile:plaintext atomically:YES];
    
    AESKey * key = [[[AESKeyGenerator alloc] init] generate:128 onError:&error];
    AESCipher * cipher = [[AESCipher alloc] init:ENCRYPT withKey:key];
    NSData * iv = cipher.iv;
    
    NSOutputStream * output = [NSOutputStream outputStreamToFileAtPath:ciphertext append:NO];
    CipherOutputStream * cos = [[CipherOutputStream alloc] initWith:output cipher:cipher];
    [cos open];
    [cos write:[random bytes] maxLength:[random length]];
    [cos close];

    cipher = [[AESCipher alloc] init:DECRYPT withKey:key iv:iv];
    NSData * ciphertext_data = [NSData dataWithContentsOfFile:ciphertext];
    NSOutputStream * byteArrayOutput = [NSOutputStream outputStreamToMemory];
    CipherOutputStream * cos2 = [[CipherOutputStream alloc] initWith:byteArrayOutput cipher:cipher];
    [cos2 open];
    [cos2 write:[ciphertext_data bytes] maxLength:[ciphertext_data length]];
    [cos2 close];
    NSData * decryptedBytes = [byteArrayOutput propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
    
    STAssertEqualObjects(random, decryptedBytes, @"Plaintext values should have been equal");
}
@end
