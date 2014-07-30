//
//  AiMWorkOrderDetailViewController.h
//  AiM Mobile
//
//  Created by norredm on 7/23/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AiMWorkOrder.h"
#import "AiMUser.h"
#import "AiMAction.h"

@interface AiMWorkOrderDetailViewController : UIViewController

@property AiMWorkOrder *workOrder;
//@property int workOrderIndex;
@property (strong, nonatomic) AiMUser *currentUser;

@end
