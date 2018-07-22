//
//  SetMO+CoreDataProperties.h
//  PushUps
//
//  Created by Limitation on 7/22/18.
//  Copyright © 2018 DEL. All rights reserved.
//
//

#import "SetMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SetMO (CoreDataProperties)

+ (NSFetchRequest<SetMO *> *)fetchRequest;

@property (nonatomic) BOOL completed;
@property (nonatomic) int32_t count;
@property (nonatomic) int32_t id;
@property (nullable, nonatomic, retain) DayMO *belongsToDay;

@end

NS_ASSUME_NONNULL_END
