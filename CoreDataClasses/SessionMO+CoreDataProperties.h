//
//  SessionMO+CoreDataProperties.h
//  PushUps
//
//  Created by Limitation on 7/22/18.
//  Copyright © 2018 DEL. All rights reserved.
//
//

#import "SessionMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SessionMO (CoreDataProperties)

+ (NSFetchRequest<SessionMO *> *)fetchRequest;

@property (nonatomic) BOOL completed;
@property (nonatomic) int32_t id;
@property (nonatomic) int32_t maxValue;
@property (nonatomic) int32_t minValue;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, retain) AthleteMO *completedByAthlete;
@property (nullable, nonatomic, retain) DayMO *currentDay;
@property (nullable, nonatomic, retain) AthleteMO *currentlyForAthlete;
@property (nullable, nonatomic, retain) NSSet<DayMO *> *daysArray;

@end

@interface SessionMO (CoreDataGeneratedAccessors)

- (void)addDaysArrayObject:(DayMO *)value;
- (void)removeDaysArrayObject:(DayMO *)value;
- (void)addDaysArray:(NSSet<DayMO *> *)values;
- (void)removeDaysArray:(NSSet<DayMO *> *)values;

@end

NS_ASSUME_NONNULL_END
