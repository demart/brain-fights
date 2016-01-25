//
//  UserProfileModel.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/6/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "UserProfileModel.h"

@implementation UserProfileModel


// Время последнего обновления в формате даты
-(NSDate*) getLastStatisticsUpdateDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *date = [formatter dateFromString:self.lastStatisticsUpdate];
    return date;
}

// Время последней активности в формате даты
-(NSDate*) getLastActivityTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *date = [formatter dateFromString:self.lastActivityTime];
    return date;
}


@end
