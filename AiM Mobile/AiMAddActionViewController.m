//
//  AiMAddActionViewController.m
//  AiM Mobile
//
//  Created by norredm on 7/23/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import "AiMAddActionViewController.h"

@interface AiMAddActionViewController ()
@property (weak, nonatomic) IBOutlet UILabel *sliderLabel;

@end

@implementation AiMAddActionViewController

- (IBAction)saveActionButton:(UIBarButtonItem *)sender
{
    //Check to make sure action is valid
    
    
    
    
    //If so, unwind to detail view.
    //If not, alert user.
    
}
- (IBAction)sliderTimeChanged:(UISlider *)sender
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setRoundingIncrement:[NSNumber numberWithFloat:0.5]];
    [formatter setRoundingMode:NSNumberFormatterRoundDown];
    
    [formatter setMaximumFractionDigits:1];
    NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:sender.value]];
    
    if(sender.value < 1){
        self.sliderLabel.text = @"30 minutes";
    }else if(sender.value < 1.5){
        self.sliderLabel.text = @"1 hour";
    }else if(sender.value == 8){
        self.sliderLabel.text = @"8+ hours";
    }else{
        self.sliderLabel.text = [NSString stringWithFormat:@"%@ hours", numberString];
    }
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}





#pragma mark - Navigation

/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
