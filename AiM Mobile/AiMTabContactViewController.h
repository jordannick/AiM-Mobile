//
//  AiMTabContactViewController.h
//  AiM Mobile
//
//  Created by norredm on 7/30/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AiMWorkOrder.h"
#import "AiMUser.h"

@interface AiMTabContactViewController : UIViewController

@property AiMWorkOrder *workOrder;
@property (strong, nonatomic) AiMUser *currentUser;

@end
