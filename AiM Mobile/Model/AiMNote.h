//
//  AiMNote.h
//  AiM Mobile
//
//  Created by norredm on 7/28/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AiMNote : NSObject

@property(strong, nonatomic) NSString *noteID;
@property(strong, nonatomic) NSString *note;
@property(strong, nonatomic) NSString *author;
@property(strong, nonatomic) NSDate *date;
@property(strong, nonatomic) NSString *error;

@end
