//
//  DayMO+CoreDataClass.m
//  PushUps
//
//  Created by Limitation on 7/22/18.
//  Copyright © 2018 DEL. All rights reserved.
//
//

#import "DayMO+CoreDataClass.h"

#import "SessionMO+CoreDataProperties.h"

@implementation DayMO

- (void)markCompleted {
    self.completed = YES;
    SessionMO *currentSession = self.belongsToSession;
    NSInteger numberOfDaysForCurrentSession = [currentSession.daysArray count] - 1;
    if (self.id == numberOfDaysForCurrentSession) {
        [currentSession markCompleted];
    }
}

@end
