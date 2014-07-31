//
//  AiMTabNotesViewController.m
//  AiM Mobile
//
//  Created by norredm on 7/31/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import "AiMTabNotesViewController.h"
#import "AiMTabBarViewController.h"
#import "AiMNote.h"

@interface AiMTabNotesViewController ()

@end

@implementation AiMTabNotesViewController

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
    // Do any additional setup after loading the view.
    [self initScrollView];

}
-(void)initScrollView
{
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat tabBarHeight = self.tabBarController.tabBar.frame.size.height;
    CGFloat screenHeight = self.view.frame.size.height - navBarHeight - tabBarHeight;
    CGFloat padding = 30;
    
    
    NSLog(@"ScreenHeight: %f   VS  ViewHeight: %f", screenHeight, self.view.frame.size.height);
    
    CGRect fullScreenRect=[[UIScreen mainScreen] applicationFrame];
    CGRect screenRect = CGRectMake(0, 0, self.view.frame.size.width, screenHeight);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:screenRect];
    //scrollView.bounds = CGRectMake(100, 100, 100, 100);
    self.view = scrollView;
    
    
    AiMTabBarViewController *parentVc = (AiMTabBarViewController*)self.tabBarController;
    CGSize frameSize = self.view.frame.size;
    CGFloat lastYPosition = navBarHeight + padding;
    CGFloat labelHeight = 50;
    CGFloat textViewHeight = 100;
    
    
    //NSArray *notes = parentVc.workOrder.phase.notesArray;
    
    NSArray *notes = @[@"This is #1", @"This is #2", @"This is #3", @"This is #4", @"This is #5"];
    for (NSString *note in notes) {
        NSLog(@"Note: %@", note);
        
        CGFloat halfScreen = frameSize.width/2 - 20;
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(20, lastYPosition, halfScreen, labelHeight)];
        name.textAlignment = NSTextAlignmentLeft;
        name.text = note;
        [self.view addSubview:name];
        
        UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(halfScreen, lastYPosition, halfScreen, labelHeight)];
        date.textAlignment = NSTextAlignmentRight;
        date.text = @"05/14/14";
        [self.view addSubview:date];
        lastYPosition += padding + labelHeight;
        
        
        UITextView *note = [[UITextView alloc] initWithFrame:CGRectMake(20, lastYPosition, halfScreen*2, textViewHeight)];
        note.text = @"This is a test description";
        [self.view addSubview:note];
        
        lastYPosition += textViewHeight + padding;
        
        
        
    }
    
    UIView *lastView = [self.view.subviews lastObject];
    CGFloat endOfFrameY = lastView.frame.origin.y + lastView.frame.size.height + navBarHeight;
    
    
    
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.view.subviews) {
        CGFloat old = contentRect.size.height;
        contentRect = CGRectUnion(contentRect, view.frame);
        CGFloat new = contentRect.size.height;
        
        NSLog(@"%f --> %f", old, new);
    }
    contentRect.size.height = contentRect.size.height + tabBarHeight;
    scrollView.contentSize = contentRect.size;
    scrollView.contentOffset = CGPointZero;
    scrollView.backgroundColor = [UIColor whiteColor];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"New orientation: %d", toInterfaceOrientation);
    NSLog(@"FrameW: %f, FrameH: %f", self.view.frame.size.width, self.view.frame.size.height);
    NSLog(@"BoundsW: %f, BoundsH :%f", self.view.bounds.size.width, self.view.bounds.size.height);
    [self initScrollView];
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
