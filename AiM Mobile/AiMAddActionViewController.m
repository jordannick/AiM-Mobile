//
//  AiMAddActionViewController.m
//  AiM Mobile
//
//  Created by norredm on 7/23/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import "AiMAddActionViewController.h"

@interface AiMAddActionViewController () <UITextViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *sliderLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveActionButton;
@property (strong, nonatomic) NSString *actionTime;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextView *notesTextField;

@end

@implementation AiMAddActionViewController
    


- (IBAction)sliderTimeChanged:(UISlider *)sender
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setRoundingIncrement:[NSNumber numberWithFloat:0.5]];
    [formatter setRoundingMode:NSNumberFormatterRoundDown];
    
    [formatter setMaximumFractionDigits:1];
    NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:sender.value]];
    
    if(sender.value < 1){
        self.sliderLabel.text = self.actionTime = @"30 minutes";
    }else if(sender.value < 1.5){
        self.sliderLabel.text = self.actionTime = @"1 hour";
    }else if(sender.value == 8){
        self.sliderLabel.text = self.actionTime = @"8+ hours";
    }else{
        self.sliderLabel.text = self.actionTime = [NSString stringWithFormat:@"%@ hours", numberString];
    }
    
}

-(void)dismissKeyboard {
    [self.notesTextField resignFirstResponder];
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.scrollView setDelegate:self];
    
    _actionToAdd = [[AiMAction alloc] init];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //CGRect screenSize = [[UIScreen mainScreen] bounds];
    //[self.scrollView setContentSize:CGSizeMake(screenSize.size.width, screenSize.size.height)];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"TESTT");
    [self.scrollView setContentOffset:CGPointMake(0, 150) animated:YES];
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


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    //Check to make sure action is valid
    //If so, unwind to detail view.
    //If not, alert user.
    
    if (sender != self.saveActionButton) return;
    else
    {
        //set the action
        
        self.actionToAdd.workOrderID = self.workOrder.taskID;
        self.actionToAdd.name = @"replace this name";
        self.actionToAdd.time = self.actionTime;
        self.actionToAdd.note = self.notesTextField.text;
        
    }

    
}

@end
