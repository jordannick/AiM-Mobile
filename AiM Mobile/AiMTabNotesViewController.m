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
#import "AiMCustomNoteCell.h"
#import <QuartzCore/QuartzCore.h>

@interface AiMTabNotesViewController ()

@property BOOL reversed;
@property NSArray *noteArray;
@property UIDeviceOrientation lastKnownOrientation;
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
    //[self initScrollView];
    NSLog(@"Yah loaded!");
    
    
    AiMTabBarViewController *vc = (AiMTabBarViewController*)self.parentViewController;
    self.noteArray = vc.workOrder.phase.notesArray;
    
    
    
    if([self.noteArray count] == 0){
        AiMNote *newNote = [[AiMNote alloc] init];
        newNote.error = @"No notes for this work order.";
        
        self.noteArray = [NSArray arrayWithObject:newNote];
        
        self.tableView.rowHeight = MAX(self.view.frame.size.height, self.view.frame.size.width);
    }
    
    
    NSLog(@"Top : %f  Bot:  %f", self.topLayoutGuide.length, self.bottomLayoutGuide.length);
    
    
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self setTableViewInset];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setTableViewInset];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

-(void)setTableViewInset
{
    CGFloat topOffset = MIN(self.navigationController.navigationBar.frame.size.height, self.navigationController.navigationBar.frame.size.width);
    if(![UIApplication sharedApplication].statusBarHidden){
        topOffset += MIN([UIApplication sharedApplication].statusBarFrame.size.height,[UIApplication sharedApplication].statusBarFrame.size.width);
    }
    CGFloat bottomOffset = MIN(self.tabBarController.tabBar.frame.size.height, self.tabBarController.tabBar.frame.size.width);
    self.tableView.contentInset = UIEdgeInsetsMake(topOffset, 0, bottomOffset, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(topOffset, 0, bottomOffset, 0);
    
    //CAGradientLayer *bg = [AiMBackground lightBlueGradient];
    //CGFloat side = MAX(self.view.frame.size.height, self.view.frame.size.width);
    //bg.frame = CGRectMake(-150, -150, side+300, side+300);
    //[self.view.layer insertSublayer:bg atIndex:0];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
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


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"M/d/yy"];
    AiMCustomNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReuseNoteCell"];
    if(!cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomNoteCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    AiMNote *note = [self.noteArray objectAtIndex:[indexPath row]];
    if(note.error){
        cell.error.text = note.error;
        cell.monthDay.text = @"";
        cell.year.text = @"";
        cell.name.text = @"";
        cell.note.text = @"";
        cell.view0.backgroundColor = cell.view1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }else{
        if(note.date){
            cell.monthDay.text = [df stringFromDate:note.date];
            [df setDateFormat:@"yyyy"];
            cell.year.text = [df stringFromDate:note.date];
        }
        cell.name.text = note.author;
        cell.note.text = note.note;
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"YAH! here!");
    // Return the number of rows in the section.
    return [self.noteArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //AiMCustomNoteCell *cell = (AiMCustomNoteCell*)[tableView cellForRowAtIndexPath:indexPath];
//    if(cell.note.contentSize.height > cell.note.frame.size.height){
//        NSLog(@"WE HAVE A WINNER!");
//    }
    // Retrieve our object to give to our size manager.
//    AiMNote *object = (AiMNote*)[self.noteArray objectAtIndex:[indexPath row]];
//    
//    NSLog(@"Height: %uL", object.note.length);
    
    return 127;
}
/*
-(void)initScrollView
{
    //Initialize scrollView
    CGRect screenRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:screenRect];
    self.view = scrollView; self.scrollView = scrollView;
    
    //Create fake notes for testing
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
    
    //Get workOrder from parent view controller
    AiMTabBarViewController *parentVc = (AiMTabBarViewController*)self.tabBarController;
    NSArray *phaseNotes = parentVc.workOrder.phase.notesArray;
    
    //Reverse array elements to sort by descending date;
    NSEnumerator *enumerator = [phaseNotes reverseObjectEnumerator];
    phaseNotes = [enumerator allObjects];
    
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
        lineSpacer.backgroundColor = [UIColor colorWithRed:0.141 green:0.263 blue:0.431 alpha:1]; /*#24436e*/ /*
        [self.view addSubview:lineSpacer];
        
        lastYPosition += padding/2;
    }
    
    if([phaseNotes count] == 0uL){
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
            NSLog(@"ViewHeight: %f width: %f", view.frame.size.height, view.frame.size.width);
        }
        scrollView.contentSize = contentRect.size;
        scrollView.contentOffset = CGPointZero;
    }
}
*/
@end
