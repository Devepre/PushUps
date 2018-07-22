//
//  SessionMO+CoreDataClass.h
//  PushUps
//
//  Created by Limitation on 7/22/18.
//  Copyright © 2018 DEL. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AthleteMO, DayMO;

NS_ASSUME_NONNULL_BEGIN

@interface SessionMO : NSManagedObject

- (void)markCompleted;

@end

NS_ASSUME_NONNULL_END

#import "SessionMO+CoreDataProperties.h"
