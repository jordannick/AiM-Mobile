//
//  AiMCustomTableCell.m
//  AiM Mobile
//
//  Created by norredm on 7/29/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import "AiMCustomTableCell.h"

@implementation AiMCustomTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(int)getRowHeight
{
    return self.proposal.frame.size.height + self.workCode.frame.size.height + 20;
}

@end
