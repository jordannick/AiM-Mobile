//
//  AiMTabBarViewController.h
//  AiM Mobile
//
//  Created by norredm on 7/30/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AiMUser.h"
#import "AiMWorkOrder.h"

@interface AiMTabBarViewController : UITabBarController

@property AiMWorkOrder *workOrder;
@property (strong, nonatomic) AiMUser *currentUser;

@end
