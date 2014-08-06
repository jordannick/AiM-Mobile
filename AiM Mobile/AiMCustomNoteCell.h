//
//  AiMCustomNoteCell.h
//  AiM Mobile
//
//  Created by norredm on 8/5/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AiMCustomNoteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UITextView *note;
@property (weak, nonatomic) IBOutlet UILabel *error;
@property (weak, nonatomic) IBOutlet UILabel *monthDay;
@property (weak, nonatomic) IBOutlet UILabel *year;
@property (weak, nonatomic) IBOutlet UIView *view0;
@property (weak, nonatomic) IBOutlet UIView *view1;



@end
