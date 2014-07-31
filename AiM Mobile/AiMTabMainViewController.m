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
@property (weak, nonatomic) IBOutlet UINavigationItem *title;


@end

@implementation AiMTabMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    self.navigationItem.title = @"OMG...!";
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    AiMTabBarViewController *parentVc = (AiMTabBarViewController*)self.tabBarController;
    self.currentUser = parentVc.currentUser;
    self.workOrder = parentVc.workOrder;
    parentVc.navigationItem.title = self.workOrder.taskID;
    
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc]initWithTitle:@"New Action" style:UIBarButtonItemStyleBordered target:self action:@selector(addAction)];
    
    parentVc.navigationItem.rightBarButtonItem = actionButton;
    
    
    UIView *lastView = [[self.scrollView subviews] lastObject];
    lastView = self.bottomView;
    float sizeOfContent = lastView.frame.origin.y + lastView.frame.size.height;
    NSLog(@"Size of content: %f\nFrame: %f", sizeOfContent, self.view.bounds.size.height-self.navigationController.navigationBar.frame.size.height);
   
    
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat oldFrame = self.scrollView.bounds.origin.y;
    NSLog(@"This is oldFrame origin Y: %f", oldFrame);
    CGRect newBounds = CGRectMake(0 , navBarHeight, self.view.frame.size.width, sizeOfContent);
    self.scrollView.bounds = newBounds;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, sizeOfContent);

    
    [self loadInitialData];
    


    
}
-(void)addAction
{
    [self performSegueWithIdentifier:@"New Action" sender:self];
}
- (IBAction)actionButtonClick:(id)sender {
    [self performSegueWithIdentifier:@"New Action" sender:self ];
}
-(void)loadInitialData
{
    if(![self.workOrder.roomNum isEqual:[NSNull null]]){
        self.location.text = [NSString stringWithFormat:@"%@ (%@)", [self.workOrder.building capitalizedString], self.workOrder.roomNum];
    }else{
        self.location.text = [self.workOrder.building capitalizedString];
    }
    
    
    //self.textView.text = self.workOrder.phase.description ? self.workOrder.description : self.workOrder.phase.description;
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
    

    //NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:startDate];
    
    //NSLog(@"%ld/%ld/%ld", (long)[components month], (long)[components day], (long)[components year]);
    //[self.workOrder.phase.estStart]
    
    //self.estDate.text = [NSString stringWithFormat:@"%@ - %@"];
    
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
