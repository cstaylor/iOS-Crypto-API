@implementation NSString (PEM)
-(NSData*)strip:(NSString*) header {
    NSString * start = [NSString stringWithFormat:@"-----BEGIN %@-----", header];
    NSString * end = [NSString stringWithFormat:@"-----END %@-----", header];
    BOOL     f_key  = FALSE;
    NSMutableString *s_key = [[NSMutableString alloc] init];
    NSArray  *a_key = [self componentsSeparatedByString:@"\n"];
    
    for (NSString *a_line in a_key) {
        if ([a_line isEqualToString:start]) {
            f_key = TRUE;
        }
        else if ([a_line isEqualToString:end]) {
            f_key = FALSE;
        }
        else if (f_key) {
            [s_key appendString:a_line];
        }
    }
    if (s_key.length == 0) return(nil);
    return [NSData dataFromBase64String:s_key];
}
@end
