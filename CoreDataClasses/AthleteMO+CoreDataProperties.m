//
//  AthleteMO+CoreDataProperties.m
//  PushUps
//
//  Created by Limitation on 7/22/18.
//  Copyright © 2018 DEL. All rights reserved.
//
//

#import "AthleteMO+CoreDataProperties.h"

@implementation AthleteMO (CoreDataProperties)

+ (NSFetchRequest<AthleteMO *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Athlete"];
}

@dynamic maxPower;
@dynamic currentMax;
@dynamic currentSessionCompletion;
@dynamic estimatedFinishDate;
@dynamic maxPerSession;
@dynamic stillToDo;
@dynamic totalCount;
@dynamic totalMax;
@dynamic sessionsArray;
@dynamic currentTrainingSession;

@end
