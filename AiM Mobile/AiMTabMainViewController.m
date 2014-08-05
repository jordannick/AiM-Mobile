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
@property (weak, nonatomic) IBOutlet UIView *bottomInnerView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *shop;
@property (weak, nonatomic) IBOutlet UILabel *workCode;
@property (weak, nonatomic) IBOutlet UILabel *created;
@property (weak, nonatomic) IBOutlet UILabel *estDate;






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
}


-(void)loadInitialData
{
    
    if(![self.workOrder.roomNum isEqual:[NSNull null]]){
        self.location.text = [NSString stringWithFormat:@"%@ (%@)", [self.workOrder.building capitalizedString], self.workOrder.roomNum];
    }else{
        self.location.text = [self.workOrder.building capitalizedString];
    }
    [self.location sizeToFit];
    
    self.textView.text = self.workOrder.phase.description;
    [self.textView setFont:[UIFont systemFontOfSize:16]];

    self.bottomView.backgroundColor = self.workOrder.phase.priorityColor;
    
    self.priority.text = self.workOrder.phase.priority;
    self.shop.text = self.workOrder.phase.shop;
    self.workCode.text = self.workOrder.phase.workCode;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yy"];
    
    self.created.text = [formatter stringFromDate:self.workOrder.dateCreated];
    NSDate *startDate = self.workOrder.phase.estStart;
    NSDate *endDate = self.workOrder.phase.estEnd;
    self.estDate.text = [NSString stringWithFormat:@"%@ - %@", [formatter stringFromDate:startDate], [formatter stringFromDate:endDate]];
    
}
-(void)setScrollViewInsets
{
    CGFloat topOffset;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    UIDeviceOrientation otherOrientation = [[UIDevice currentDevice] orientation];
    if(orientation == 4 || orientation == 3){
        NSLog(@"Orientation Landscape! %d", orientation);
        topOffset = 32 + [UIApplication sharedApplication].statusBarFrame.size.width;
    }
    else{
        NSLog(@"Orientation Portrait! %d", orientation);
        topOffset = 32 + [UIApplication sharedApplication].statusBarFrame.size.height;
    }

    NSLog(@"NavBar height: %f width: %f  and statusBar height: %f width: %f   %f   statbarorient: %d vs %d", self.navigationController.navigationBar.frame.size.height, self.navigationController.navigationBar.frame.size.width, [UIApplication sharedApplication].statusBarFrame.size.height, [UIApplication sharedApplication].statusBarFrame.size.width, self.view.frame.origin.y, [[UIApplication sharedApplication] statusBarOrientation], otherOrientation);
    
    UIEdgeInsets oldInset = self.scrollView.contentInset;
    //self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    
    
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIEdgeInsets edgeInset = UIEdgeInsetsMake(topOffset, 0, self.tabBarController.tabBar.frame.size.height, 0);
    //self.scrollView.contentInset = edgeInset;
    self.scrollView.scrollIndicatorInsets = edgeInset;
    //self.scrollView.contentOffset = CGPointMake(0, 0);
    
    NSLog(@"Old: %f New: %f", oldInset.top, self.scrollView.contentInset.top);
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self setScrollViewInsets];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setScrollViewInsets];
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
