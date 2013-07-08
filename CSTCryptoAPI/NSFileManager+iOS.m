@implementation NSFileManager (iOS)
-(NSString*)fileInDocuments:(NSString*)fileName onError:(NSError**)error{
    __autoreleasing NSError * tempError;
    error = error == NULL ? &tempError : error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    if ( ![self fileExistsAtPath:documentsDirectory] ) {
        NSURL *path = [NSURL fileURLWithPath:documentsDirectory isDirectory:YES];
        [self createDirectoryAtURL:path withIntermediateDirectories:YES attributes:nil error:error];
    }
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    return dataPath;
}
@end
