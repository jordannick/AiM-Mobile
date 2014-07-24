//
//  AiMAction.h
//  AiM Mobile
//
//  Created by norredm on 7/23/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AiMAction : NSObject

@property (strong, nonatomic) NSNumber *workOrderID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *time;
@property (strong, nonatomic) NSString *note;

@end
