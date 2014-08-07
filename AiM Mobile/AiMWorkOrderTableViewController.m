//
//  AiMWorkOrderTableViewController.m
//  AiM Mobile
//
//  Created by Nick on 8/5/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import "AiMWorkOrderTableViewController.h"
#import "AiMWorkOrderDetailViewController.h"
#import "AiMWorkOrder.h"
#import "AiMCustomTableCell.h"
#import "AiMTabMainViewController.h"
#import "AiMTabBarViewController.h"
#import "AiMCurrentUser.h"


@interface AiMWorkOrderTableViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

@property (weak, nonatomic) IBOutlet UILabel *loggedInLabel;
//@property (strong, nonatomic) NSMutableArray *sectionTitles;
//@property (nonatomic) NSInteger numSections;
//@property (strong, nonatomic) NSMutableArray *numInEachSection;
@property (strong,nonatomic) NSArray *uniqueDates;
@property (strong, nonatomic) AiMCurrentUser *currentUser;

@end

@implementation AiMWorkOrderTableViewController

/*
- (IBAction)sortBySegmentedControl:(UISegmentedControl *)sender
{
    NSInteger segIndex = sender.selectedSegmentIndex;
    if(segIndex == 0)   //Sort by DATE
    {
        [self sortWorkOrdersByDate];
        
    } else if(segIndex == 1) //Sort by PRIORITY
    {
        [self sortWorkOrdersByPriority];
    }
    
    [self.tableView reloadData];
}
 */


- (void) sortWorkOrdersByPriority
{
    //Sorting
    NSArray *sortedArray = [_currentUser.user.workOrders sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        AiMWorkOrder *first = (AiMWorkOrder*) obj1;
        AiMWorkOrder *second = (AiMWorkOrder*) obj2;
        
        if (!first.phase.priorityID || !second.phase.priorityID){
            return NSOrderedSame;
        }
        
        if ([first.phase.priorityID compare:second.phase.priorityID] == NSOrderedAscending) {
            return NSOrderedAscending;
        } else if ([first.phase.priorityID compare:second.phase.priorityID] == NSOrderedDescending)
        {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    //Section grouping organization - unused
    /*
     
    [self.sectionTitles removeAllObjects];
    [self.numInEachSection removeAllObjects];
    
    for (int i = 0; i < [sortedArray count]; i++)
    {
        NSString *priority = ((AiMWorkOrder*)sortedArray[i]).phase.priority;
        
        BOOL foundMatch = NO;
        NSInteger sectionIndex = 0;
        NSNumber *iNum = [NSNumber numberWithInt:i];
        
        if(priority == nil)
        {
            NSLog(@"Why is this nil...");
            break;
        }
        if (i == 0)
        {
            [self.sectionTitles addObject:priority];
            [self.numInEachSection addObject:[NSMutableArray arrayWithObject:iNum]];
        } else {
            for (NSString *testString in self.sectionTitles)
            {
                //If section title already exists, don't add it, but increment that section #
                if ([testString isEqualToString:priority])
                {
                    foundMatch = YES;
                    [((NSMutableArray*)self.numInEachSection[sectionIndex]) addObject:iNum];
                    break;
                }
            }
            //No existing found, so add section string, and create new # for new section
            if (!foundMatch)
            {
                [self.sectionTitles addObject:priority];
                [self.numInEachSection addObject:[NSMutableArray arrayWithObject:iNum]];
                sectionIndex++;
            }
        }
    }
    self.numSections = [self.sectionTitles count];
    */
    
    _currentUser.user.workOrders = [sortedArray mutableCopy];
}


- (void) sortWorkOrdersByDate
{
    //Sorting
    NSArray *sortedArray = [_currentUser.user.workOrders sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        AiMWorkOrder *first = (AiMWorkOrder*) obj1;
        AiMWorkOrder *second = (AiMWorkOrder*) obj2;
        
        if ([first.dateCreated compare:second.dateCreated] == NSOrderedDescending) {
            return NSOrderedAscending;
        } else if ([first.dateCreated compare:second.dateCreated] == NSOrderedAscending)
        {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
        
    }];
    
    //Section grouping organization - unused
    /*
     
    [self.sectionTitles removeAllObjects];
    [self.numInEachSection removeAllObjects];
    
    for (int i = 0; i < [sortedArray count]; i++)
    {
        NSDate *date = ((AiMWorkOrder*)sortedArray[i]).dateCreated;
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yy"];
        NSString *dateString = [df stringFromDate:date];
        
        BOOL foundMatch = NO;
        NSInteger sectionIndex = 0;
        NSNumber *iNum = [NSNumber numberWithInt:i];
        if(dateString == nil)
        {
            NSLog(@"Why is this nil...");
            break;
        }
        if (i == 0)
        {
            [self.sectionTitles addObject:dateString];
            [self.numInEachSection addObject:[NSMutableArray arrayWithObject:iNum]];
        } else {
            for (NSString *testString in self.sectionTitles)
            {
                //If section title already exists, don't add it, but increment that section #
                if ([testString isEqualToString:dateString])
                {
                    foundMatch = YES;
                    [((NSMutableArray*)self.numInEachSection[sectionIndex]) addObject:iNum];
                    break;
                }
            }
            //No existing found, so add section string, and create new # for new section
            if (!foundMatch)
            {
                [self.sectionTitles addObject:dateString];
                [self.numInEachSection addObject:[NSMutableArray arrayWithObject:iNum]];
                sectionIndex++;
            }
        }
    }
    self.numSections = [self.sectionTitles count];
     */
    
    _currentUser.user.workOrders = [sortedArray mutableCopy];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Get the singleton instance
    _currentUser = [AiMCurrentUser shareUser];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    /*
    self.numSections = 1;
    self.sectionTitles = [[NSMutableArray alloc] init];
    self.numInEachSection = [[NSMutableArray alloc] init];
     */
    
    self.navBar.title = [NSString stringWithFormat:@"Work Orders (%d)", [_currentUser.user.workOrders count]];
    //self.loggedInLabel.text = [NSString stringWithFormat:@"Logged in as: %@", _currentUser.user.username];
    [self.navigationItem setHidesBackButton:YES];
    
    self.navigationController.toolbarHidden = NO;
    
    UIBarButtonItem *options = [[UIBarButtonItem alloc] initWithTitle:@"Options" style:UIBarButtonItemStylePlain target:self action:@selector(viewOptions)];
    
    UIBarButtonItem *space1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *username = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%@", _currentUser.user.username] style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIBarButtonItem *space2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *signout = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:nil];

    
    
    [self setToolbarItems:@[options, space1, username, space2, signout]];
    
    
    for (int i = 0; i < [self.currentUser.user.workOrders count]; i++)
    {
        NSLog(@"%@", ((AiMWorkOrder *)self.currentUser.user.workOrders[i]).organization.contactName);
 
    }
    
    [self sortWorkOrdersByDate];
    [self loadInitialData];
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.toolbarHidden = NO;
}


- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.toolbarHidden = YES;
}


- (void)loadInitialData
{
    
}


- (void)viewOptions
{
    NSLog(@"Got to view options");
    UIActionSheet *actionSheet =  [[UIActionSheet alloc] initWithTitle:@"Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Sort by date", @"Sort by priority", nil];
    
    
    [actionSheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]){
        if (buttonIndex == 0)
            [self sortWorkOrdersByDate];
        else if (buttonIndex == 1)
            [self sortWorkOrdersByPriority];
        
        [self.tableView reloadData];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [_currentUser.user.workOrders count];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"SelectionSegue" sender:self];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"CellIdentifier";
    
    //Get workOrder for cell
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"M/d"];
    
    [indexPath section];
    [indexPath row];
    
    AiMWorkOrder *workOrder = [self.currentUser.user.workOrders objectAtIndex:[indexPath row]];
    
    AiMCustomTableCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSRange range = [workOrder.phase.workCode rangeOfString:@"_"];
    NSString *workCodeWord = [workOrder.phase.workCode substringWithRange:NSMakeRange(range.location+1, workOrder.phase.workCode.length - (range.location+1))];
    workCodeWord = [workCodeWord capitalizedString];
    
    cell.proposal.text = workOrder.taskID;
    if(!workOrder.phase.roomNum)
        cell.location.text = [workOrder.building capitalizedString];
    else
        cell.location.text = [[NSString stringWithFormat:@"%@ (%@)", workOrder.building, workOrder.phase.roomNum] capitalizedString];
    cell.workCode.text = workCodeWord;
    cell.priorityLetter.text = [workOrder.phase.priority substringWithRange:NSMakeRange(0, 1)];

    cell.dayMonth.text = [df stringFromDate:workOrder.dateCreated];
    [df setDateFormat:@"yyyy"];
    cell.year.text = [df stringFromDate:workOrder.dateCreated];
    
    cell.priorityView.backgroundColor = workOrder.phase.priorityColor;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //self.navigationController.toolbarHidden = YES;
    
    if([[segue identifier] isEqualToString:@"SelectionSegue"])
    {
        AiMTabBarViewController *vc = [segue destinationViewController];
        
        id whatIsThis = [[vc viewControllers] firstObject];
        
        NSLog(@"This is workOrder: %@", [whatIsThis class]);
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        vc.workOrder = _currentUser.user.workOrders[[indexPath row]];
    }
}


@end
