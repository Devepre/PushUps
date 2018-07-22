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
#import "DataController.h"
#import "AthleteMO+CoreDataProperties.h"
#import "SetMO+CoreDataProperties.h"

@implementation DayMO

- (void)markCompleted {
    self.completed = YES;
    // TODO: handle logging to the Calendar
    
    SessionMO *currentSession = self.belongsToSession;
    
    NSInteger numberOfDaysForCurrentSession = [currentSession.daysArray count] - 1;
    if (self.id == numberOfDaysForCurrentSession) {
        [currentSession markCompleted];
    } else {
        DayMO *nextDay = [self nextDay];
        [DataController sharedInstance].currentAthlete.currentTrainingSession.currentDay = nextDay;
        
        // Setting first Set of the Day as current
        [DataController sharedInstance].currentAthlete.currentTrainingSession.currentDay.currentSet = [nextDay firstSet];
    }
}


- (DayMO *)nextDay {
    NSInteger currentID = self.id + 1;
    
    NSSet *set = [DataController sharedInstance].currentAthlete.currentTrainingSession.daysArray;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %d", currentID];
    set = [set filteredSetUsingPredicate:predicate];
    NSLog(@"%@", set);
    
    return [set anyObject];
}


- (SetMO *)firstSet {
    NSInteger currentID = 0;
    
    NSSet *set = self.setArray;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %d", currentID];
    set = [set filteredSetUsingPredicate:predicate];
    NSLog(@"%@", set);
    
    return [set anyObject];
}

@end
