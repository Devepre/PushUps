//
//  SessionMO+CoreDataClass.m
//  PushUps
//
//  Created by Limitation on 7/22/18.
//  Copyright © 2018 DEL. All rights reserved.
//
//

#import "SessionMO+CoreDataClass.h"

#import "AthleteMO+CoreDataProperties.h"

@implementation SessionMO

- (void)markCompleted {
    self.completed = YES;
    AthleteMO *currentAthlete = self.currentlyForAthlete;
//    NSInteger numberOfSessionsForCurrentAthlete = [currentAthlete.ses count] - 1;
//    if (self.id == numberOfDaysForCurrentSession) {
//        [currentSession markCompleted];
//    }
}

@end
