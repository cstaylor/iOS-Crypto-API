@implementation AESKey

-(id)init:(NSData*)data keySize:(NSUInteger)size
{
    if ( self = [super init] )
    {
        self.keyData = data;
        self.size = size;
    }
    return self;
}

-(NSData*)key
{
    return self.keyData;
}

-(NSNumber*)keyType
{
    return [NSNumber numberWithUnsignedInt:AES_KEY_TYPE];
}

-(NSNumber*)keySize
{
    return [NSNumber numberWithUnsignedInt:self.size];
}

@end
