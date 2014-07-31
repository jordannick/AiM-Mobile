//
//  AiMTabBarViewController.m
//  AiM Mobile
//
//  Created by norredm on 7/30/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import "AiMTabBarViewController.h"
#import "AiMAddActionViewController.h"


@interface AiMTabBarViewController ()

@property (strong, nonatomic) AiMAction *action;
@property (strong, nonatomic) UIAlertView *actionAddedAlert;

@end

@implementation AiMTabBarViewController

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
    
    self.actionAddedAlert = [[UIAlertView alloc] initWithTitle:@"Work Order" message:[NSString stringWithFormat:@"New action added to work order %@", self.action.workOrderID] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dismissAlert
{
    [self.actionAddedAlert dismissWithClickedButtonIndex:0 animated:YES];
    

}


- (IBAction)unwindToTabView:(UIStoryboardSegue *)segue
{
   NSLog(@"Got to the unwind");
    
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
        
        NSLog(@"Show alert here");
        
        NSTimeInterval interval = 2;
        
        
        [self.actionAddedAlert show];
        
        [self performSelector:@selector(dismissAlert) withObject:self.actionAddedAlert afterDelay:interval];
        
        
        
        
        //Test
        for (int i = 0; i < [_currentUser.syncQueue count]; i++)
        {
            
            NSLog(@"syncQueue time: %@", [(AiMAction *)[_currentUser.syncQueue objectAtIndex:i] time]);
        }
        NSLog(@"-----");
        
    }
    
    
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
