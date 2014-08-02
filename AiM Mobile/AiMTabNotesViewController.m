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
#import "AiMBackground.h"
#import <QuartzCore/QuartzCore.h>

@interface AiMTabNotesViewController ()

@property BOOL reversed;
@property (strong, nonatomic) UIScrollView *scrollView;

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
    self.reversed = NO;
    // Do any additional setup after loading the view.
    [self initScrollView];

}
-(void)initScrollView
{
    //Initialize scrollView
    CGRect screenRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:screenRect];
    self.view = scrollView; self.scrollView = scrollView;
    
    //Get workOrder from parent view controller
    AiMTabBarViewController *parentVc = (AiMTabBarViewController*)self.tabBarController;
    NSArray *phaseNotes = parentVc.workOrder.phase.notesArray;
    if([phaseNotes count] > 0)
        NSLog(@"Woo there is an element! %d", [phaseNotes count]);
    
    
    AiMNote *newNote = [[AiMNote alloc] init];
    //Create fake notes for testing
    NSMutableArray *fakeNotes = [[NSMutableArray alloc] init];
    [fakeNotes addObject:newNote];
    for (int i = 0; i < 5; i++) {
        newNote.note = @"This morning I went to the Co-op for breakfast. I had some oatmeal, black Columbian coffee, and a breakfast wrap.";
        newNote.author = @"Maddy Berry";
        newNote.date = [NSDate date];
        [fakeNotes addObject:newNote];
    }
    NSLog(@"This is fakeNotes: %@", fakeNotes);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yy  hh:mm a"];
    
    //Positioning variables
    CGSize frameSize = self.view.frame.size;
    CGFloat lastYPosition = 0;
    CGFloat labelHeight = 50;
    CGFloat textViewHeight = 100;
    CGFloat padding = 30;
    CGFloat leftPadding = 0;
    CGFloat halfScreen = frameSize.width/2 - 20;
    CGRect noNotesRect = CGRectMake(0, padding, self.view.frame.size.width, labelHeight);
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if(orientation == 3 || orientation == 4){
        halfScreen = frameSize.height/2 - 20;
        noNotesRect = CGRectMake(0, padding, self.view.frame.size.height, labelHeight);
    }else{
        leftPadding = 0;
    }
    
    //Create view elements for each note
    for (AiMNote *note in phaseNotes) {
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(leftPadding+20, lastYPosition, halfScreen, labelHeight)];
        name.textAlignment = NSTextAlignmentLeft;
        name.textColor = [UIColor darkGrayColor];
        name.font = [UIFont fontWithName:@"Helvetica-Bold" size:[name.font pointSize]];
        name.text = note.author;
        [self.view addSubview:name];
        
        UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(leftPadding+halfScreen+20, lastYPosition, halfScreen, labelHeight)];
        date.textAlignment = NSTextAlignmentRight;
        date.textColor = [UIColor darkGrayColor];
        date.text = [formatter stringFromDate:note.date];
        date.font = [UIFont fontWithName:[date.font fontName] size:[date.font pointSize]-4];
        NSLog(@"Date from note: %@ --> %@", note.date, [formatter stringFromDate:note.date]);
        [self.view addSubview:date];
        lastYPosition += padding/2 + labelHeight;
        
        
        UITextView *noteTextView = [[UITextView alloc] initWithFrame:CGRectMake(leftPadding+20, lastYPosition, halfScreen*2, textViewHeight)];
        noteTextView.text = note.note;
        noteTextView.backgroundColor = [UIColor clearColor];
        noteTextView.selectable = NO; noteTextView.editable = NO; noteTextView.scrollEnabled = NO;
        [noteTextView sizeToFit];
        [self.view addSubview:noteTextView];
        
        lastYPosition += noteTextView.frame.size.height + padding/2;
        
        CGFloat lineWidth = halfScreen*2+20;
        UILabel *lineSpacer = [[UILabel alloc] initWithFrame:CGRectMake(leftPadding+10, lastYPosition, lineWidth, 1)];
        lineSpacer.backgroundColor = [UIColor colorWithRed:0.141 green:0.263 blue:0.431 alpha:1]; /*#24436e*/
        [self.view addSubview:lineSpacer];
        
        lastYPosition += padding/2;
    }

    if([phaseNotes count] == 0uL){
        NSLog(@"Success!");
        UILabel *noNotesLabel = [[UILabel alloc] initWithFrame:noNotesRect];
        noNotesLabel.textAlignment = NSTextAlignmentCenter;
        noNotesLabel.textColor = [UIColor lightGrayColor];
        noNotesLabel.text = @"No notes for this work order.";
        [self.view addSubview:noNotesLabel];
    }else{
        //Set contentSize of scrollView
        CGRect contentRect = CGRectZero;
        for (UIView *view in self.view.subviews) {
            contentRect = CGRectUnion(contentRect, view.frame);
        }
        scrollView.contentSize = contentRect.size;
        scrollView.contentOffset = CGPointZero;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setBackgroundColor];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    CGFloat screenHeight =[UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth =[UIScreen mainScreen].bounds.size.width;
    self.view.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    [self initScrollView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setBackgroundColor
{
    CGFloat squareSize = MAX([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
    CAGradientLayer *bgLayer = [AiMBackground lightBlueGradient];
    bgLayer.frame = self.view.superview.frame;
    bgLayer.frame = CGRectMake(bgLayer.frame.origin.x, bgLayer.frame.origin.y, squareSize, squareSize);
    [self.view.superview.layer insertSublayer:bgLayer atIndex:0];
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



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return 4;
}




@end
