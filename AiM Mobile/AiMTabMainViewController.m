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
@property (weak, nonatomic) IBOutlet UINavigationItem *titleBar;

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
    
    
    NSArray *items = [self.navigationController.navigationBar items];
    
    
    
    AiMTabBarViewController *parentVc = (AiMTabBarViewController*)self.tabBarController;
    self.currentUser = parentVc.currentUser;
    self.workOrder = parentVc.workOrder;
    
    // Do any additional setup after loading the view.
    UIView *lastView = [[self.scrollView subviews] lastObject];
    lastView = self.bottomView;
    float sizeOfContent = lastView.frame.origin.y + lastView.frame.size.height;
    
    NSLog(@"Size of content: %f\nFrame: %f", sizeOfContent, self.view.bounds.size.height-self.navigationController.navigationBar.frame.size.height);
   
    
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    CGFloat oldFrame = self.scrollView.bounds.origin.y;
    
    NSLog(@"This is oldFrame origin Y: %f", oldFrame);
    CGRect newBounds = CGRectMake(0 , navBarHeight, self.view.frame.size.width, sizeOfContent);
    
    self.scrollView.bounds = newBounds;
    //self.scrollView.clipsToBounds = YES;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, sizeOfContent);
    //self.scrollView.bounds = newBounds;
    //self.scrollView.scrollEnabled = NO;
    
    //self.scrollView.frame = [[UIScreen mainScreen] applicationFrame];

    
    NSLog(@"Bounds are: %f AND %f", self.view.frame.size.height, self.scrollView.frame.size.height);
    
    [self loadInitialData];
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    
    
    UINavigationItem *navItem = [[navBar items] objectAtIndex:1];
    [navItem setTitle:@"TEST"];
    
    NSLog(@"This: %lu",(unsigned long)[[navBar items] count]);
    
    
}
-(void)loadInitialData
{
    
    //self.navigationController.navigationBar.topItem.title = @"TEST";
    //self.titleBar
    //self.navigationItem.title = @"TEST";
    //self.titleBar.title = @"TEST";
    //self.titleBar.title = self.workOrder.taskID;
    self.location.text = [NSString stringWithFormat:@"%@ - %@", self.workOrder.building, self.workOrder.roomNum];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yy"];
    NSDate *startDate = self.workOrder.phase.estStart;
    NSDate *endDate = self.workOrder.phase.estEnd;
    //NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:startDate];
    
    //NSLog(@"%ld/%ld/%ld", (long)[components month], (long)[components day], (long)[components year]);
    //[self.workOrder.phase.estStart]
    
    //self.estDate.text = [NSString stringWithFormat:@"%@ - %@"];
    
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
//    NSDate *date = [formatter dateFromString:tempDate];
//    
//    NSCalendar *calender = [NSCalendar currentCalendar];
//    NSLog(@"Time zone: %@", [calender timeZone]);
//    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
//    
//    NSString *dateString = [NSString stringWithFormat:@"%d/%d/%d", [components month], [components day], [components year]];
    
    /*
     @property (weak, nonatomic) IBOutlet UITextView *textView;
     @property (weak, nonatomic) IBOutlet UILabel *location;
     @property (weak, nonatomic) IBOutlet UILabel *estDate;
     @property (weak, nonatomic) IBOutlet UILabel *shop;
     @property (weak, nonatomic) IBOutlet UILabel *workCode;
     @property (weak, nonatomic) IBOutlet UILabel *created;
     */
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 0)
                             animated:NO];
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
