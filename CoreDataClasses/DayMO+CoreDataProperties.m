//
//  DayMO+CoreDataProperties.m
//  PushUps
//
//  Created by Limitation on 7/22/18.
//  Copyright © 2018 DEL. All rights reserved.
//
//

#import "DayMO+CoreDataProperties.h"

@implementation DayMO (CoreDataProperties)

+ (NSFetchRequest<DayMO *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Day"];
}

@dynamic completed;
@dynamic breakIntervalDays;
@dynamic id;
@dynamic numberOfSetsCompleted;
@dynamic relaxIntervalSeconds;
@dynamic belongsToSession;
@dynamic currentSet;
@dynamic setArray;

@end
