//
//  SetMO+CoreDataClass.m
//  PushUps
//
//  Created by Limitation on 7/22/18.
//  Copyright © 2018 DEL. All rights reserved.
//
//

#import "SetMO+CoreDataClass.h"

#import "DayMO+CoreDataProperties.h"

@implementation SetMO

- (void)markCompleted {
    self.completed = YES;
    DayMO *currentDay = self.belongsToDay;
    NSInteger numberOfSetsForCurrentDay = [currentDay.setArray count] - 1;
    if (self.id == numberOfSetsForCurrentDay) {
        [currentDay markCompleted];
    }
}

@end
