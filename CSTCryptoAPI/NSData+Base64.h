@interface NSData (Base64)
- (NSString *)base64EncodedString;
- (NSString *)base64EncodedStringWithSeparateLines:(BOOL)separateLines;
+ (NSData *)dataFromBase64String:(NSString *)aString;
@end
