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
#import "DataController.h"
#import "DayMO+CoreDataProperties.h"
#import "SetMO+CoreDataProperties.h"

@implementation SessionMO

- (void)markCompleted {
    self.completed = YES;
    
    AthleteMO *currentAthlete = self.currentlyForAthlete;
    NSInteger numberOfSessionsForCurrentAthlete = [currentAthlete.sessionsArray count] - 1;
    if (self.id == numberOfSessionsForCurrentAthlete) {
        [currentAthlete markCompleted];
    } else {
        SessionMO *nextSession = [self nextSession];
        [DataController sharedInstance].currentAthlete.currentTrainingSession = nextSession;
        
        // Setting first Day of the next Session as current
        DayMO *nextDay = [nextSession firstDay];
        [DataController sharedInstance].currentAthlete.currentTrainingSession.currentDay = nextDay;
        
        // Setting first Set of the Day as current
        [DataController sharedInstance].currentAthlete.currentTrainingSession.currentDay.currentSet = [nextDay firstSet];
    }
}


- (SessionMO *)nextSession {
    NSInteger currentID = self.id + 1;
    
    NSSet *set = [DataController sharedInstance].currentAthlete.sessionsArray;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %d", currentID];
    set = [set filteredSetUsingPredicate:predicate];
    NSLog(@"%@", set);
    
    return [set anyObject];
}


- (DayMO *)firstDay {
    NSInteger currentID = 0;
    
    NSSet *set = self.daysArray;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %d", currentID];
    set = [set filteredSetUsingPredicate:predicate];
    NSLog(@"%@", set);
    
    return [set anyObject];
}

@end
