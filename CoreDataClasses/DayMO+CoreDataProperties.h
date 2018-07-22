//
//  DayMO+CoreDataProperties.h
//  PushUps
//
//  Created by Limitation on 7/22/18.
//  Copyright © 2018 DEL. All rights reserved.
//
//

#import "DayMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DayMO (CoreDataProperties)

+ (NSFetchRequest<DayMO *> *)fetchRequest;

@property (nonatomic) BOOL completed;
@property (nonatomic) int32_t breakIntervalDays;
@property (nonatomic) int32_t id;
@property (nonatomic) int32_t numberOfSetsCompleted;
@property (nonatomic) int32_t relaxIntervalSeconds;
@property (nullable, nonatomic, retain) SessionMO *belongsToSession;
@property (nullable, nonatomic, retain) SetMO *currentSet;
@property (nullable, nonatomic, retain) NSSet<SetMO *> *setArray;

@end

@interface DayMO (CoreDataGeneratedAccessors)

- (void)addSetArrayObject:(SetMO *)value;
- (void)removeSetArrayObject:(SetMO *)value;
- (void)addSetArray:(NSSet<SetMO *> *)values;
- (void)removeSetArray:(NSSet<SetMO *> *)values;

@end

NS_ASSUME_NONNULL_END
