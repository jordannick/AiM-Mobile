//
//  AiMContactTableViewController.m
//  AiM Mobile
//
//  Created by norredm on 8/4/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import "AiMContactTableViewController.h"
#import "AiMTabBarViewController.h"
#import "AiMWorkOrder.h"

@interface AiMContactTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *department;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (strong, nonatomic) AiMTabBarViewController *parentVc;



@end

@implementation AiMContactTableViewController

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
    [self loadInitialData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)loadInitialData
{
    AiMWorkOrder *workOrder = self.parentVc.workOrder;
    
    
    //self.emailCell.detailTextLabel.text =@"TEST!";
    
    NSLog(@"Name: %@ Requestor: %@  ContactName:  %@  Phone  %@", workOrder.organization.name, workOrder.organization.requestor, workOrder.organization.contactName, workOrder.organization.contactPhone);
    //Set fields to current Work Order
    self.department.text = workOrder.organization.requestor;
    self.name.text = workOrder.organization.contactName;
    self.phone.text = workOrder.organization.contactPhone;
    self.email.text = workOrder.organization.contactEmail;
    
    
    /*
     @property(strong, nonatomic) NSString *name;
     @property(strong, nonatomic) NSString *requestor;
     @property(strong, nonatomic) NSString *contactName;
     @property(strong, nonatomic) NSString *contactEmail;
     @property(strong, nonatomic) NSNumber *contactPhone;
     
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO: Fix telprompt code
    //Not sure if telprompt works, need to test on real device.
    if(indexPath.row == 2){
        NSLog(@"Phone hit!");
        NSString *testPhoneNum = @"9712350512";
        NSString *phoneNumber = [@"telprompt://" stringByAppendingString:testPhoneNum];
        NSLog(@"phone: %@", phoneNumber);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }else if(indexPath.row == 3){
        NSLog(@"Email hit!");
    }
}
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}
*/
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Contact Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    

    
    return cell;
}
*/

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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Getters and Setters
-(AiMTabBarViewController *)parentVc
{
    if(!_parentVc)
    {
        _parentVc = (AiMTabBarViewController*)self.parentViewController;
    }
    return _parentVc;
}
@end
