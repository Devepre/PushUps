//
//  AthleteMO+CoreDataProperties.h
//  PushUps
//
//  Created by Limitation on 7/22/18.
//  Copyright © 2018 DEL. All rights reserved.
//
//

#import "AthleteMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AthleteMO (CoreDataProperties)

+ (NSFetchRequest<AthleteMO *> *)fetchRequest;

@property (nonatomic) BOOL maxPower;
@property (nonatomic) int32_t currentMax;
@property (nonatomic) float currentSessionCompletion;
@property (nullable, nonatomic, copy) NSDate *estimatedFinishDate;
@property (nonatomic) int32_t maxPerSession;
@property (nonatomic) int32_t stillToDo;
@property (nonatomic) int64_t totalCount;
@property (nonatomic) int32_t totalMax;
@property (nullable, nonatomic, retain) NSSet<SessionMO *> *sessionsArray;
@property (nullable, nonatomic, retain) SessionMO *currentTrainingSession;

@end

@interface AthleteMO (CoreDataGeneratedAccessors)

- (void)addCompletedSessionsObject:(SessionMO *)value;
- (void)removeCompletedSessionsObject:(SessionMO *)value;
- (void)addCompletedSessions:(NSSet<SessionMO *> *)values;
- (void)removeCompletedSessions:(NSSet<SessionMO *> *)values;

@end

NS_ASSUME_NONNULL_END
