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
#import "DataController.h"
#import "AthleteMO+CoreDataProperties.h"
#import "SetMO+CoreDataProperties.h"
#import "SessionMO+CoreDataClass.h"

@implementation SetMO

- (void)markCompleted {
    self.completed = YES;
    // TODO: handle logging to the Calendar
    DayMO *currentDay = self.belongsToDay;
    
    NSInteger numberOfSetsForCurrentDay = [currentDay.setArray count] - 1;
    if (self.id == numberOfSetsForCurrentDay) {
        [currentDay markCompleted];
    } else {
        [DataController sharedInstance].currentAthlete.currentTrainingSession.currentDay.currentSet = [self nextSet];
    }
}


- (SetMO *)nextSet {
    NSInteger currentID = self.id + 1;

    NSSet *set = [DataController sharedInstance].currentAthlete.currentTrainingSession.currentDay.setArray;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %d", currentID];
    set = [set filteredSetUsingPredicate:predicate];
    NSLog(@"%@", set);
    
    return [set anyObject];
}


- (BOOL)isLastInDay {
    BOOL result = (self.id == [self.belongsToDay.setArray count] - 1);
    return result;
}


@end
