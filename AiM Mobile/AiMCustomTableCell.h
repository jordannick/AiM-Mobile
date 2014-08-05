//
//  AiMCustomTableCell.h
//  AiM Mobile
//
//  Created by norredm on 7/29/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AiMCustomTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *proposal;
@property (weak, nonatomic) IBOutlet UILabel *workCode;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *priorityLetter;
@property (weak, nonatomic) IBOutlet UILabel *dayMonth;
@property (weak, nonatomic) IBOutlet UILabel *year;
@property (weak, nonatomic) IBOutlet UIView *priorityView;



-(int)getRowHeight;

@end
