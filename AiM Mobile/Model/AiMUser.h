//
//  AiMUser.h
//  AiM Mobile
//
//  Created by Nick on 7/22/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AiMWorkOrder.h"

@interface AiMUser : NSObject

@property(strong, nonatomic) NSString *username;
@property(strong, nonatomic) NSMutableArray *workOrders;
@property(strong, nonatomic) NSDate *lastLogin;

- (BOOL) addWorkOrder: (AiMWorkOrder *) newWorkOrder;

- (void) updateLastLogin;

@end
