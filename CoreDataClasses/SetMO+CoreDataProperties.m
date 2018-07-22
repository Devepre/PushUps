//
//  SetMO+CoreDataProperties.m
//  PushUps
//
//  Created by Limitation on 7/22/18.
//  Copyright © 2018 DEL. All rights reserved.
//
//

#import "SetMO+CoreDataProperties.h"

@implementation SetMO (CoreDataProperties)

+ (NSFetchRequest<SetMO *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Set"];
}

@dynamic completed;
@dynamic count;
@dynamic id;
@dynamic belongsToDay;

@end
