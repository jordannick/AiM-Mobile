//
//  AiMWorkOrderTableViewController.h
//  AiM Mobile
//
//  Created by Nick on 7/22/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AiMWorkOrder.h"
#import "AiMUser.h"


@interface AiMWorkOrderTableViewController : UITableViewController

//@property (strong, nonatomic) NSMutableArray *workOrders;
//@property (strong, nonatomic) NSString *currentUser;
@property (strong, nonatomic) AiMUser *currentUser;

@end
