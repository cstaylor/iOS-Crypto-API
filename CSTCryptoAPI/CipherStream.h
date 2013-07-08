@interface CipherOutputStream : NSOutputStream
-(id)initWith:(NSOutputStream*)input cipher:(id<Cipher>)cipher;
@end