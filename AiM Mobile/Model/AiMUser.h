//
//  AiMUser.h
//  AiM Mobile
//
//  Created by Nick on 7/22/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AiMWorkOrder.h"
#import "AiMLoginViewController.h"
#import "AiMAction.h"

@interface AiMUser : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate>

@property(strong, nonatomic) NSString *username;
@property(strong, nonatomic) NSMutableArray *workOrders;
@property(strong, nonatomic) NSDate *lastLogin;
@property(strong, nonatomic) NSMutableArray *syncQueue;
@property(strong, readonly) NSURLSession *session;
@property(atomic) int completionCount;

- (BOOL) addWorkOrder: (AiMWorkOrder *) newWorkOrder;

- (void) updateLastLogin;

-(void) syncWorkOrders;

-(void)sendRequestTo:(NSURL*)url withLoginBool:(BOOL)login andSender:(UIViewController*)sender;



@end
