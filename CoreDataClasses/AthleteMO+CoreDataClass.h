//
//  AthleteMO+CoreDataClass.h
//  PushUps
//
//  Created by Limitation on 7/22/18.
//  Copyright © 2018 DEL. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SessionMO;

NS_ASSUME_NONNULL_BEGIN

@interface AthleteMO : NSManagedObject

@property (strong, nonatomic, readonly) NSString   *setsDescription;
@property (assign, nonatomic, readonly) NSUInteger  setPushupNumber;

- (void)markCompleted;

@end

NS_ASSUME_NONNULL_END

#import "AthleteMO+CoreDataProperties.h"
