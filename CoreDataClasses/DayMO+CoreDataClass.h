//
//  DayMO+CoreDataClass.h
//  PushUps
//
//  Created by Limitation on 7/22/18.
//  Copyright © 2018 DEL. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SessionMO, SetMO;

NS_ASSUME_NONNULL_BEGIN

@interface DayMO : NSManagedObject

- (void)markCompleted;

@end

NS_ASSUME_NONNULL_END

#import "DayMO+CoreDataProperties.h"
