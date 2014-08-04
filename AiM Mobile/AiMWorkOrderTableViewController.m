//
//  AiMWorkOrderTableViewController.m
//  AiM Mobile
//
//  Created by Nick on 7/22/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import "AiMWorkOrderTableViewController.h"
#import "AiMWorkOrderDetailViewController.h"
#import "AiMWorkOrder.h"
#import "AiMCustomTableCell.h"
#import "AiMTabMainViewController.h"
#import "AiMTabBarViewController.h"

@interface AiMWorkOrderTableViewController ()
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
@property (weak, nonatomic) IBOutlet UILabel *loggedInLabel;
@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property (nonatomic) NSInteger numSections;
@property (strong, nonatomic) NSMutableArray *numInEachSection;
@property (strong,nonatomic) NSArray *uniqueDates;
//@property (strong, nonatomic) AiMCustomTableCell *cellPrototype;

@end

@implementation AiMWorkOrderTableViewController


- (IBAction)onSyncButtonPress:(UIBarButtonItem *)sender {
    
    [_currentUser syncWorkOrders];
    
}
- (IBAction)sortBySegmentedControl:(UISegmentedControl *)sender
{
    NSInteger segIndex = sender.selectedSegmentIndex;
    NSLog(@"This is segIndex : %ld", (long)segIndex);
   // NSArray *sortedArray;
    if(segIndex == 0)   //Sort by DATE
    {
        for (AiMWorkOrder *workOrder in _currentUser.workOrders) {
            NSLog(@"Pre sort workorders date: %@", workOrder.dateCreated);
        }
        [self sortWorkOrdersByDate];
        
        /*
        for (AiMWorkOrder *workOrder in _currentUser.workOrders) {
            NSLog(@"12Post sort workorders: %@", workOrder.dateCreated);
        }
        */
       
    }else if(segIndex == 1) //Sort by PRIORITY
    {
        for (AiMWorkOrder *workOrder in _currentUser.workOrders) {
            NSLog(@"Pre sort workorders priorityID: %@", workOrder.phase.priorityID);
        }
        
        [self sortWorkOrdersByPriority];
        
        for (AiMWorkOrder *workOrder in _currentUser.workOrders) {
            NSLog(@"Post sort workorders priorityID: %@", workOrder.phase.priorityID);
        }
    }
    
    //_currentUser.workOrders = [NSMutableArray arrayWithArray:sortedArray];
    [self.tableView reloadData];
    
}

- (void) sortWorkOrdersByPriority
{
   // NSLog(@"Pre sort workorders: %@", _currentUser.workOrders);
    NSArray *sortedArray = [_currentUser.workOrders sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        AiMWorkOrder *first = (AiMWorkOrder*) obj1;
        AiMWorkOrder *second = (AiMWorkOrder*) obj2;
        
        if (!first.phase.priorityID || !second.phase.priorityID){
            NSLog(@"nonexistent work order: %@ or %@", first.phase.priorityID, second.phase.priorityID);
            return NSOrderedSame;
        }
        
        NSLog(@"num1: %@, num2: %@", first.phase.priorityID, second.phase.priorityID);
        
        if ([first.phase.priorityID compare:second.phase.priorityID] == NSOrderedAscending) {
            return NSOrderedAscending;
        } else if ([first.phase.priorityID compare:second.phase.priorityID] == NSOrderedDescending)
        {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    [self.sectionTitles removeAllObjects];
    [self.numInEachSection removeAllObjects];
    
    
    
    for (int i = 0; i < [sortedArray count]; i++)
    {
        //NSNumber *priorityID = ((AiMWorkOrder*)sortedArray[i]).phase.priorityID;
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
    
    
    
    _currentUser.workOrders = [sortedArray mutableCopy];
   // NSLog(@"Post sort workorders: %@", _currentUser.workOrders);

}

- (void) sortWorkOrdersByDate
{
    //NSLog(@"Pre sort workorders: %@", _currentUser.workOrders);
    
    NSArray *sortedArray = [_currentUser.workOrders sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        AiMWorkOrder *first = (AiMWorkOrder*) obj1;
        AiMWorkOrder *second = (AiMWorkOrder*) obj2;
        
        if ([first.dateCreated compare:second.dateCreated] == NSOrderedDescending) {
            return NSOrderedDescending;
        } else if ([first.dateCreated compare:second.dateCreated] == NSOrderedAscending)
        {
            return NSOrderedAscending;
        } else {
            return NSOrderedSame;
        }
            
        
    }];
    //NSLog(@"Post sort workorders: %@", _currentUser.workOrders);
    //Acquire formatting variables for table groupings
  
    [self.sectionTitles removeAllObjects];
   [self.numInEachSection removeAllObjects];
    //self.sectionTitles = [[NSMutableArray alloc] init];
    //self.numInEachSection = [[NSMutableArray alloc] init];
    
    
    
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
    _currentUser.workOrders = [sortedArray mutableCopy];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //test
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //
    
    self.numSections = 1;
    
    self.sectionTitles = [[NSMutableArray alloc] init];
    self.numInEachSection = [[NSMutableArray alloc] init];
    
    //[self.sectionTitles addObject:@""];
    //[self.numInEachSection addObject:@([_currentUser.workOrders count])];
    
    NSLog(@"This is my ID: %@", self);

   // self.navBar.title = self.currentUser.username;
    self.loggedInLabel.text = [NSString stringWithFormat:@"Logged in as: %@", _currentUser.username];
    [self.navigationItem setHidesBackButton:YES];


    //NSLog(@"This is JSON: %@", self.currentUser.workOrders);
    
    for (int i = 0; i < [self.currentUser.workOrders count]; i++)
    {
        NSLog(@"%@", ((AiMWorkOrder *)self.currentUser.workOrders[i]).organization.contactName);
    
    
    }
    
    [self sortWorkOrdersByDate];
    [self loadInitialData];
    
}

-(void)loadInitialData
{
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
    //return 1;
    NSLog(@"Number of sections is %d", [self.numInEachSection count]);
    return [self.numInEachSection count];
    //return self.numSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    //return [_currentUser.workOrders count];
    NSLog(@"Number of sections in %d is %d", section, [[self.numInEachSection objectAtIndex:section] count]);
    return [[self.numInEachSection objectAtIndex:section] count];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sectionTitles objectAtIndex:section];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"SelectionSegue" sender:self];
    //[self performSegueWithIdentifier:@"TabBarController" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"[IndexPath row] = %ld", (long)[indexPath row]);
    static NSString *simpleTableIdentifier = @"CellIdentifier";
    //Get workOrder for cell
    
    
    [indexPath section];
    [indexPath row];
    //NSLog(@"indexpath.row is %d", indexPath.row);
    //NSLog(@"work orders are: %@", [_currentUser.workOrders objectAtIndex:0]);
    
    NSNumber *index = [[self.numInEachSection objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
    AiMWorkOrder *workOrder = [self.currentUser.workOrders objectAtIndex:[index intValue]];
    
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

    cell.backgroundColor = workOrder.phase.priorityColor;
    
    NSLog(@"Priority: %@", workOrder.phase.priority);
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    NSLog(@"Preparing for segue");
    if([[segue identifier] isEqualToString:@"SelectionSegue"])
    {
        AiMTabBarViewController *vc = [segue destinationViewController];
        
        id whatIsThis = [[vc viewControllers] firstObject];
        
        NSLog(@"This is workOrder: %@", [whatIsThis class]);
        
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        NSNumber *index = [[self.numInEachSection objectAtIndex:[path section]] objectAtIndex:[path row]];
//        
//        vc.workOrder = _currentUser.workOrders[[index intValue]];
//        vc.currentUser = _currentUser;
        
        
        vc.workOrder = _currentUser.workOrders[[index intValue]];
        //vc.workOrderIndex = [index intValue];
        vc.currentUser = _currentUser;
        
    }

    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */
@end
