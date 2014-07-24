//
//  AiMUser.m
//  AiM Mobile
//
//  Created by Nick on 7/22/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import "AiMUser.h"

@implementation AiMUser


- (BOOL) addWorkOrder:(AiMWorkOrder *)newWorkOrder
{
    [self.workOrders addObject:newWorkOrder];
    return YES;
}

-(void)syncWorkOrders
{
    //Send each workOrder object in syncQueue to server.
    
    for (int i = 0; i < [self.syncQueue count]; i++) {
        AiMAction *action = self.syncQueue[i];
        //Call push function to save actions to server.
    }
    //Clear syncQueue
    [self.syncQueue removeAllObjects];
}


-(void)updateLastLogin
{
    self.lastLogin = [NSDate date];
}



@end
