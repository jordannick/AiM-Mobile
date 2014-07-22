//
//  AiMWorkOrderPhase.h
//  AiM Mobile
//
//  Created by Nick on 7/22/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AiMWorkOrderPhasePriority.h"

@interface AiMWorkOrderPhase : NSObject

@property(strong, nonatomic) NSString *description;
@property(strong, nonatomic) NSString *createdBy;
@property(strong, nonatomic) NSString *funding;
@property(strong, nonatomic) NSString *shop;
@property(strong, nonatomic) NSString *location;
@property(strong, nonatomic) NSDate *dateCreated;
@property(strong, nonatomic) NSDate *estStart;
@property(strong, nonatomic) NSDate *estEnd;
@property(strong, nonatomic) AiMWorkOrderPhasePriority *priority;
@property(strong, nonatomic) NSString *workCodeGroup;
@property(strong, nonatomic) NSString *workCode;

@end
