//
//  AiMWorkOrder.h
//  AiM Mobile
//
//  Created by Nick on 7/22/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AiMOrganization.h"
#import "AiMWorkOrderPhase.h"

@interface AiMWorkOrder : NSObject

@property(strong, nonatomic) NSNumber *taskID;
@property(strong, nonatomic) NSString *category;
@property(strong, nonatomic) NSString *description;
@property(strong, nonatomic) NSString *createdBy;
@property(strong, nonatomic) NSDate *dateCreated;
//@property(strong, nonatomic) NSArray *dateComponents;
@property(strong,nonatomic) NSString *sortDate;
@property(strong, nonatomic) NSNumber *customerRequest;
@property(strong, nonatomic) NSString *type;
@property(strong, nonatomic) AiMOrganization *organization;
@property(strong, nonatomic) AiMWorkOrderPhase *phase;

@end
