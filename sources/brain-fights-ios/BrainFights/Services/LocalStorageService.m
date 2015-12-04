//
//  LocalStorageService.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/7/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "LocalStorageService.h"

@implementation LocalStorageService

+ (void) setSettingsKey:(NSString *)key withObject:(NSObject *)value {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

+ (NSObject*) getSettingsValueByKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}


+(void)saveImageToLocalCache:(NSString *)imageName withData:(UIImage*)uiImage {
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* path = [[NSString alloc] initWithFormat: @"%@/Images/%@", documentsPath, imageName];
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:[path stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:&error];
    } else {
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    }
    if (error) {
        NSLog(@"Error directory for images: %@", path);
        NSLog(@"Error : %@", error);
    }
    
    NSData *imageData = UIImageJPEGRepresentation(uiImage, 1.0);
    BOOL ok = [[NSFileManager defaultManager] createFileAtPath:path
                                                      contents:imageData attributes:nil];
    if (!ok) {
        NSLog(@"Error creating file %@", path);
    }
}

+(UIImage *)loadImageFromLocalCache:(NSString *)imageName {
    //    NSLog(@"loadImageFromLocalCache with %@", imageName);
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* path = [[NSString alloc] initWithFormat: @"%@/Images/%@", documentsPath, imageName];
    
    //return nil;
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (fileExists) {
        NSFileHandle* myFileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
        UIImage* loadedImage = [UIImage imageWithData:[myFileHandle readDataToEndOfFile]];
        return loadedImage;
    } else {
        NSLog(@"File doesn't exist: %@", path);
    }
    return nil;
}



@end
