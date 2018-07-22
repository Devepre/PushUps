//
//  SessionMO+CoreDataProperties.m
//  PushUps
//
//  Created by Limitation on 7/22/18.
//  Copyright © 2018 DEL. All rights reserved.
//
//

#import "SessionMO+CoreDataProperties.h"

@implementation SessionMO (CoreDataProperties)

+ (NSFetchRequest<SessionMO *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Session"];
}

@dynamic completed;
@dynamic id;
@dynamic maxValue;
@dynamic minValue;
@dynamic title;
@dynamic completedByAthlete;
@dynamic currentDay;
@dynamic currentlyForAthlete;
@dynamic daysArray;

@end
