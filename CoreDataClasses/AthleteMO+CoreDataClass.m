//
//  AthleteMO+CoreDataClass.m
//  PushUps
//
//  Created by Limitation on 7/22/18.
//  Copyright © 2018 DEL. All rights reserved.
//
//

#import "AthleteMO+CoreDataClass.h"

#import "SessionMO+CoreDataProperties.h"
#import "DayMO+CoreDataProperties.h"
#import "SetMO+CoreDataProperties.h"

@implementation AthleteMO

@synthesize setPushupNumber = _setPushupNumber;

// This method has side-effect for counting _setPushupNumber
- (NSString *)setsDescription {
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"id"
                                                               ascending:YES];
    NSArray<SetMO *> *setsArray = [self.currentTrainingSession.currentDay.setArray
                                   sortedArrayUsingDescriptors:@[descriptor]];
    NSMutableString *setsString = [[NSMutableString alloc] init];
    NSUInteger __block totalNumber = 0;
    [setsArray enumerateObjectsUsingBlock:^(SetMO * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *stringFormat = (idx < setsArray.count - 1) ? @"%d-" : @"%d+";
        [setsString appendFormat:stringFormat, obj.count];
        totalNumber += obj.count;
    }];
    
    NSString *setsLabelString = [NSString stringWithFormat:@"%@ [%@]",
                                 self.currentTrainingSession.title,
                                 setsString];
    if (!self.currentTrainingSession.title) {
        setsLabelString = @"Not assigned yet";
    }
    _setPushupNumber = totalNumber;
    
    return setsLabelString;
}


@end
