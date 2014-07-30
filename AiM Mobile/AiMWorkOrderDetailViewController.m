//
//  AiMWorkOrderDetailViewController.m
//  AiM Mobile
//
//  Created by norredm on 7/23/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import "AiMWorkOrderDetailViewController.h"

#import "AiMAddActionViewController.h"

@interface AiMWorkOrderDetailViewController () <UIActionSheetDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) AiMAction *action;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@end

@implementation AiMWorkOrderDetailViewController

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
    [self loadInitialData];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)loadInitialData
{
    //Set all labels to workOrder.value
    NSLog(@"This is workOrder : %@", self.workOrder);
    
    self.descriptionTextView.text = self.workOrder.description; //Replace with user.workOrder.description
    
    
    NSLog(@"ID: %@ DESC: %@", self.workOrder.taskID, self.workOrder.description);
    
    
}
- (IBAction)contactInfoButton:(id)sender
{
    //Create new modal view and display additional contact information.
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    NSNumber *phoneNumber = @9712350512;

    
    //NSRange range = [phoneNumber rangeOfString:@"512"];

    //NSLog(@"This is range: %lu", (unsigned long)range.location);
    
    
    [actionSheet addButtonWithTitle:[self formatPhoneNumber:phoneNumber]];
    [actionSheet addButtonWithTitle:@"brickmana@oregonstate.edu"];
    [actionSheet addButtonWithTitle:@"Cancel"];
    [actionSheet setCancelButtonIndex:2];
    
    [actionSheet showInView:self.view];
    
}

-(NSString *)formatPhoneNumber:(NSNumber*)number
{
    NSString *stringValue = [number stringValue];
    return [NSString stringWithFormat:@"(%@)-%@-%@",[stringValue substringWithRange:NSMakeRange(0, 3)],[stringValue substringWithRange:NSMakeRange(3, 3)],[stringValue substringWithRange:NSMakeRange(6, 4)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
- (IBAction)unwindToDetailView:(UIStoryboardSegue *)segue
{
    if ([segue.identifier isEqualToString:@"saveToDetail"]){
        AiMAddActionViewController *source = [segue sourceViewController];
        self.action = source.actionToAdd;
        if (self.action != nil) {
            //add to sync queue
            [_currentUser.syncQueue addObject:self.action];
            
            //add to actions log
            
            //[self.workOrder.phase.actionsLog addObject:self.action];
            //[((AiMWorkOrder*)_currentUser.workOrders[self.workOrderIndex]).phase.actionsLog addObject:self.action];
            
            /*
            for (AiMWorkOrder *printWorkOrder in _currentUser.workOrders){
                NSLog(@"Work Order %@ - Phase actions log is: %@", printWorkOrder.taskID, ((AiMAction*)printWorkOrder.phase.actionsLog).name);
                NSLog(@"  ");
            }
             */
            
            
        }
        
        //Test
        for (int i = 0; i < [_currentUser.syncQueue count]; i++)
        {
            
            NSLog(@"syncQueue time: %@", [(AiMAction *)[_currentUser.syncQueue objectAtIndex:i] time]);
        }
         NSLog(@"-----");
        
    }
    
    
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    AiMAddActionViewController *vc = [segue destinationViewController];
    vc.workOrder = self.workOrder;
    
}


@end
