//
//  Constants.m
//  BrainFights
//
//  Created by Artem Demidovich on 11/11/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "Constants.h"
#import <UIKit/UIGraphics.h>

@implementation Constants

+(UIColor*) SYSTEM_COLOR_GREEN {
    return [UIColor colorWithRed:0.0/255.0f green:176.0/255.0f blue:80.0/255.0f alpha:1.0f];
}

+(UIColor*) SYSTEM_COLOR_BLACK {
    return [UIColor colorWithRed:31.0/255.0f green:26.0/255.0f blue:23.0/255.0f alpha:1.0f];
}

+(UIColor*) SYSTEM_COLOR_LIGHT_GREY {
    return [UIColor colorWithRed:192.0/255.0f green:192.0/255.0f blue:192.0/255.0f alpha:1.0f];
}

+(UIColor*) SYSTEM_COLOR_DARK_GREY {
    return [UIColor colorWithRed:150.0/255.0f green:150.0/255.0f blue:150.0/255.0f alpha:1.0];
}

+(UIColor*) SYSTEM_COLOR_LIGHT_GREEN {
    return [UIColor colorWithRed:138.0/255.0f green:215.0/255.0f blue:95.0/255.0f alpha:1.0f];
}

+(UIColor*) SYSTEM_COLOR_ORANGE {
    return [UIColor colorWithRed:228.0/255.0f green:108.0/255.0f blue:10.0/255.0f alpha:1.0f];
}

+(UIColor*) SYSTEM_COLOR_RED {
    return [UIColor colorWithRed:192.0/255.0f green:0.0/255.0f blue:0.0/255.0f alpha:1.0f];
}

+(UIColor*) SYSTEM_COLOR_WHITE {
    return [UIColor whiteColor];
}

+ (UIImage*) imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
