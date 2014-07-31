//
//  AiMAddActionViewController.m
//  AiM Mobile
//
//  Created by norredm on 7/23/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import "AiMAddActionViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface AiMAddActionViewController () <UITextViewDelegate, UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveActionButton;
@property (strong, nonatomic) NSString *actionTime;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextView *notesTextField;
@property (weak, nonatomic) IBOutlet UILabel *selectedActionLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedTimeLabel;
@property (nonatomic) BOOL actionSelected;
@property (nonatomic) BOOL timeSelected;


@end

@implementation AiMAddActionViewController
    
- (IBAction)viewActionSheet:(id)sender {
    
    UIActionSheet *actionSheet =  [[UIActionSheet alloc] initWithTitle:@"Select an Action" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Did this", @"Did that", @"Did things", @"General Maintainence", @"This is an action", nil];
    
    
    [actionSheet showInView:self.view];
    
}

- (IBAction)cancelButtonClicked:(UIBarButtonItem *)sender {
    NSLog(@"Cancel button clicked! -");
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)saveButtonClicked:(UIBarButtonItem *)sender {
    NSLog(@"Save button clicked! -");
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]){
        self.selectedActionLabel.textColor = [UIColor blackColor];
        self.selectedActionLabel.text = [actionSheet buttonTitleAtIndex:buttonIndex];
        self.actionSelected = YES;

    }
    //NSLog(@"the button %@", [actionSheet buttonTitleAtIndex:buttonIndex]);


}



- (IBAction)sliderTimeChanged:(UISlider *)sender
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setRoundingIncrement:[NSNumber numberWithFloat:0.5]];
    [formatter setRoundingMode:NSNumberFormatterRoundDown];
    
    [formatter setMaximumFractionDigits:1];
    NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:sender.value]];
    
    self.selectedTimeLabel.textColor = [UIColor blackColor];
    
    self.timeSelected = YES;
    
    if(sender.value < 1){
        self.selectedTimeLabel.text = self.actionTime = @"30 minutes";
        
    }else if(sender.value < 1.5){
        self.selectedTimeLabel.text = self.actionTime = @"1 hour";
    }else if(sender.value == 8){
        self.selectedTimeLabel.text = self.actionTime = @"8+ hours";
    }else{
        self.selectedTimeLabel.text = self.actionTime = [NSString stringWithFormat:@"%@ hours", numberString];
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
    
    self.actionSelected = NO;
    self.actionSelected = NO;
    
    self.notesTextField.layer.borderColor = [UIColor blackColor].CGColor;
    self.notesTextField.layer.borderWidth = 1.0;
    
    _actionToAdd = [[AiMAction alloc] init];
    
    

    NSLog(@"LeftBarButton action: %@",self.navigationItem.leftBarButtonItem.title);
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //CGRect screenSize = [[UIScreen mainScreen] bounds];
    //[self.scrollView setContentSize:CGSizeMake(screenSize.size.width, screenSize.size.height)];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.textColor = [UIColor blackColor];
    if ([textView.text isEqualToString:@"Enter additional notes here"]) {
        textView.text = @"";
    }
    [self.scrollView setContentOffset:CGPointMake(0, 235) animated:YES];
    
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    if ([[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
    {
        textView.text = @"Enter additional notes here";
        textView.textColor = [UIColor grayColor];
    }
    else
        textView.textColor = [UIColor blackColor];


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

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (sender != self.saveActionButton)
        return YES;
    else
    {
        CAKeyframeAnimation * jiggleAnim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
        jiggleAnim.values = @[ [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f) ], [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f) ] ] ;
        jiggleAnim.autoreverses = YES;  jiggleAnim.repeatCount = 2.0f;  jiggleAnim.duration = 0.07f;

        if (!self.actionSelected)
        {
            self.selectedActionLabel.textColor = [UIColor redColor];
            [self.selectedActionLabel.layer addAnimation:jiggleAnim forKey:nil];
        }
        if (!self.timeSelected)
        {
            self.selectedTimeLabel.textColor = [UIColor redColor];
            [self.selectedTimeLabel.layer addAnimation:jiggleAnim forKey:nil];
        }
        if (self.actionSelected && self.timeSelected)
            return YES;
        else
            return NO;
    }
}


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
        self.actionToAdd.name = self.selectedActionLabel.text;
        self.actionToAdd.time = self.actionTime;
        self.actionToAdd.note = self.notesTextField.text;
        
    }

    
}

@end
