//
//  AiMAddActionViewController.h
//  AiM Mobile
//
//  Created by norredm on 7/23/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AiMAction.h"
#import "AiMWorkOrder.h"

@interface AiMAddActionViewController : UIViewController <UIActionSheetDelegate>

@property AiMWorkOrder *workOrder;
@property(strong, nonatomic) AiMAction *actionToAdd;


@end
