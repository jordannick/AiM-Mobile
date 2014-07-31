//
//  AiMTabMainViewController.m
//  AiM Mobile
//
//  Created by norredm on 7/30/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import "AiMTabMainViewController.h"
#import "AiMTabBarViewController.h"
#import "AiMUser.h"
#import "AiMAddActionViewController.h"


@interface AiMTabMainViewController () <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *priority;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *estDate;
@property (weak, nonatomic) IBOutlet UILabel *shop;
@property (weak, nonatomic) IBOutlet UILabel *workCode;
@property (weak, nonatomic) IBOutlet UILabel *created;





@end

@implementation AiMTabMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    AiMTabBarViewController *parentVc = (AiMTabBarViewController*)self.tabBarController;
    self.currentUser = parentVc.currentUser;
    self.workOrder = parentVc.workOrder;
    parentVc.navigationItem.title = self.workOrder.taskID;

    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 0)
                             animated:NO];
    
    [self loadInitialData];
    
    NSLog(@"L Scroll Origin:   W:   %f     H:   %f", self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    NSLog(@"L Scroll contentSize:   W:  %f     H:    %f", self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    NSLog(@"Scroll bounds:  W: %f    H: %f", self.scrollView.bounds.size.width,self.scrollView.bounds.size.height);}


-(void)loadInitialData
{
    if(![self.workOrder.roomNum isEqual:[NSNull null]]){
        self.location.text = [NSString stringWithFormat:@"%@ (%@)", [self.workOrder.building capitalizedString], self.workOrder.roomNum];
    }else{
        self.location.text = [self.workOrder.building capitalizedString];
    }
    
    self.textView.text = [self.workOrder.phase.description lowercaseString];
    [self.textView setFont:[UIFont systemFontOfSize:16]];
    self.shop.text = self.workOrder.phase.shop;
    self.workCode.text = self.workOrder.phase.workCode;
    self.created.text = self.workOrder.dateCreated;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yy"];
    NSDate *startDate = self.workOrder.phase.estStart;
    NSDate *endDate = self.workOrder.phase.estEnd;
    self.estDate.text = [NSString stringWithFormat:@"%@ - %@", [formatter stringFromDate:startDate], [formatter stringFromDate:endDate]];
    
}

-(void)viewWillDisappear:(BOOL)animated

{
    [super viewWillDisappear:animated];
    //[self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 0)
                             //animated:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    //self.scrollView.contentSize = CGSizeMake(1000, 1000);
    CGPoint newOffset = CGPointMake(0, 10);
    [self.scrollView setContentOffset:newOffset animated:NO];
    [super viewWillAppear:animated];
    NSLog(@"Scroll Origin:   W:   %f     H:   %f", self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    NSLog(@"Scroll contentSize:   W:  %f     H:    %f", self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    NSLog(@"Scroll bounds:  W: %f    H: %f", self.scrollView.bounds.size.width,self.scrollView.bounds.size.height);
    //self.scrollView.contentSize = CGSizeMake(1000, 1000);
    //self.scrollView.frame = CGRectMake(0, 0, 100, 100);
    
    //[self setUpScrollView];
    //[self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 0)
                             //animated:NO];
    //NSLog(@"Yo... %f  AND  %f", self.scrollView.frame.size.height, self.scrollView.contentSize.height);
    //[self printScrollViewStatus];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
