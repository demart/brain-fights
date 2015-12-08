//
//  GamerModel.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/8/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "GamerModel.h"

@implementation GamerModel

// Время последнего обновления в формате
-(NSDate*) getLastUpdateStatusDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    // Always use this locale when parsing fixed format date strings
    //NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    //[formatter setLocale:posix];
    NSDate *date = [formatter dateFromString:self.lastUpdateStatusDate];
    return date;
}

@end
