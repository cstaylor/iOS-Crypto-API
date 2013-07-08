enum CipherMode {
    ENCRYPT,
    DECRYPT
};

@protocol Cipher <NSObject>
-(NSData*)update:(NSData*)data onError:(NSError**)error;
-(NSData*)final:(NSError**)error;
@end