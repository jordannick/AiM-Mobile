//
//  AiMCurrentUser.m
//  AiM Mobile
//
//  Created by Nick on 8/6/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import "AiMCurrentUser.h"

@implementation AiMCurrentUser

static AiMCurrentUser *shared = NULL;

@synthesize user;

- (id)init
{
    if (self = [super init])
    {
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        if ([def objectForKey:@"currentUser"]==nil) {
            [def setObject:self.user forKey:@"currentUser"];
            [def synchronize];
        } else {
            self.user = [def objectForKey:@"currentUser"];
        }
    }
    return self;

}

+ (AiMCurrentUser *)shareUser
{

    @synchronized(shared)
    {
        if (!shared || shared == NULL) {
            shared = [[AiMCurrentUser alloc] init];
        }
        
        return shared;
    }
}

/*
- (void)dealloc
{
    [super dealloc];
}
 */

@end
