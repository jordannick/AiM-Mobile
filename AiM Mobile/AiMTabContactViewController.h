//
//  AiMTabContactViewController.h
//  AiM Mobile
//
//  Created by norredm on 8/5/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AiMTabContactViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *requestor;
@property (weak, nonatomic) IBOutlet UILabel *orgName;
@property (weak, nonatomic) IBOutlet UILabel *contactName;
@property (weak, nonatomic) IBOutlet UIButton *email;
@property (weak, nonatomic) IBOutlet UIButton *phone;
@property (weak, nonatomic) IBOutlet UILabel *method;

@end
