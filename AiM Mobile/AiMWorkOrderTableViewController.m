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

@interface AiMWorkOrderTableViewController ()
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

@end

@implementation AiMWorkOrderTableViewController

- (IBAction)sortBySegmentedControl:(UISegmentedControl *)sender
{
    NSInteger segIndex = sender.selectedSegmentIndex;
    NSLog(@"This is segIndex : %d", segIndex);
    NSArray *sortedArray;
    
    
    if(segIndex == 0)   //Sort by DATE
    {
        NSLog(@"Sorting by date...");
        sortedArray = [self.workOrders sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            AiMWorkOrder *first = (AiMWorkOrder*) obj1;
            AiMWorkOrder *second = (AiMWorkOrder*) obj2;
            
//            if (first.dateCreated < second.dateCreated) {
//                return NSOrderedAscending;
//            }else if(first.dateCreated > second.dateCreated)
//            {
//                return NSOrderedDescending;
//            }else{
//                return NSOrderedSame;
//            }
            NSLog(@"Sorting %@ with %@", first.taskID, second.taskID);
            if ([first.taskID intValue] < [second.taskID intValue]) {
                NSLog(@"Ascend");
                return NSOrderedAscending;
            }else if([first.taskID intValue] > [second.taskID intValue])
            {
                NSLog(@"Descend");
                return NSOrderedDescending;
            }else{
                NSLog(@"Same");
                return NSOrderedSame;
            }
            
            
        }];
    }else if(segIndex == 1) //Sort by PRIORITY
    {
        sortedArray = [self.workOrders sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            AiMWorkOrder *first = (AiMWorkOrder*) obj1;
            AiMWorkOrder *second = (AiMWorkOrder*) obj2;
            
//            if (<#condition#>) {
//                <#statements#>
//            }
            return NSOrderedSame;
        }];
    }
    
    self.workOrders = [NSMutableArray arrayWithArray:sortedArray];
    [self.tableView reloadData];
    
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
    
    NSLog(@"This is my ID: %@", self);

    self.navBar.title = self.currentUser;

    [self.navigationItem setHidesBackButton:YES];


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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [self.workOrders count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkOrderTableCell" forIndexPath:indexPath];
    
    //Get workOrder for cell
    AiMWorkOrder *workOrder = [self.workOrders objectAtIndex:indexPath.row];
    
    //Set cell attributes
    cell.textLabel.text = [NSString stringWithFormat:@"%@", workOrder.taskID];

    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    NSLog(@"Preparing for segue");
    if([[segue identifier] isEqualToString:@"ToWorkOrderDetail"])
    {
        AiMWorkOrderDetailViewController *vc = [segue destinationViewController];
        NSIndexPath *index = [self.tableView indexPathForSelectedRow];
        vc.workOrder = self.workOrders[[index row]];
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
