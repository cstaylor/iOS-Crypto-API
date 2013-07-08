@interface CipherOutputStream()
@property (nonatomic,strong) NSOutputStream * stream;
@property (nonatomic,strong) id<Cipher> cipher;
@end

@implementation CipherOutputStream

-(id)initWith:(NSOutputStream*)input cipher:(id<Cipher>)cipher
{
    if ( self = [super init] ) {
        self.stream = input;
        self.cipher = cipher;
    }
    return self;
}

- (NSInteger)write:(const uint8_t *)buffer maxLength:(NSUInteger)length
{
    NSError * error = nil;
    NSData * data_buffer = [NSData dataWithBytesNoCopy:(void*)buffer length:length freeWhenDone:NO];
    NSData * modified_data_buffer = [self.cipher update:data_buffer onError:&error];
    if ( !error ) return [self.stream write:[modified_data_buffer bytes] maxLength:[modified_data_buffer length]];
    return -1;
}

-(void)open
{
    [self.stream open];
}

-(void)close
{
    NSError * error = nil;
    NSData  * modified_data_buffer = [self.cipher final:&error];
    if ( !error ) [self.stream write:[modified_data_buffer bytes] maxLength:[modified_data_buffer length]];
    [self.stream close];
}

- (BOOL)hasSpaceAvailable
{
    return [self.stream hasSpaceAvailable];
}

@end
