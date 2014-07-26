//
//  AiMUser.m
//  AiM Mobile
//
//  Created by Nick on 7/22/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import "AiMUser.h"


@implementation AiMUser

@synthesize session = _session;

- (NSURLSession *)session
{
    //NSURLSession *session;
    if(!_session)
    {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    }
    return _session;
}


- (NSMutableArray *)workOrders
{
    if(!_workOrders)
    {
        _workOrders = [[NSMutableArray alloc] init];
    }
    return _workOrders;
}

- (NSMutableArray *)syncQueue
{
    if(!_syncQueue)
    {
        _syncQueue = [[NSMutableArray alloc] init];
    }
    return _syncQueue;
}


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

-(void)sendRequestTo:(NSURL*)url withLoginBool:(BOOL)login andSender:(id)sender
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    NSURLSessionDataTask *getDataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *readableData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Data: %@\nResponse: %@\nError: %@", readableData, response.URL, error);
        
        NSError *jsonParsingError = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
        NSLog(@"JSON is: %@", json);
        
        NSLog(@"ALL KEYS: %@",[json allKeys]);
        
        //if(login)
            [sender segueToOverviewTable];
        //else
            //[sender refreshTable];
    }];
    [getDataTask resume];
}
/*
 
 initial request to get the SET of WorkOrders               --CALLED ON LOGIN
 
 refresh WorkOrders                                         --CALLED ON ButtonPress or Other
 
 addActions                                                 --CALLED ON SYNC
 
 
 
 
 
 
 
 */

-(void)updateLastLogin
{
    self.lastLogin = [NSDate date];
}



@end
