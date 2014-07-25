//
//  AiMUser.h
//  AiM Mobile
//
//  Created by Nick on 7/22/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AiMWorkOrder.h"
#import "AiMAction.h"

@interface AiMUser : NSObject

@property(strong, nonatomic) NSString *username;
@property(strong, nonatomic) NSMutableArray *workOrders;
@property(strong, nonatomic) NSDate *lastLogin;
@property(strong, nonatomic) NSMutableArray *syncQueue;

@property(strong, nonatomic) NSURLSession *session;

- (BOOL) addWorkOrder: (AiMWorkOrder *) newWorkOrder;

- (void) updateLastLogin;

-(void) syncWorkOrders;



@end
