//
//  AiMCurrentUser.h
//  AiM Mobile
//
//  Created by Nick on 8/6/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AiMUser.h"

@interface AiMCurrentUser : NSObject{
    AiMUser *user;
}

@property (strong, nonatomic) AiMUser *user;

+ (AiMCurrentUser *)shareUser;

@end
