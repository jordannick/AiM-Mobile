//
//  AiMTabBarViewController.m
//  AiM Mobile
//
//  Created by norredm on 7/30/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import "AiMTabBarViewController.h"
#import "AiMAddActionViewController.h"
#import "AiMCurrentUser.h"

@interface AiMTabBarViewController ()

@property (strong, nonatomic) AiMAction *action;
@property (strong, nonatomic) AiMCurrentUser *currentUser;

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
    
    UITabBarItem *item = [self.tabBar.items objectAtIndex:1];
    if(self.workOrder.phase.notesArray){
        NSUInteger numNotes = [self.workOrder.phase.notesArray count];
        if(numNotes > 0)
            item.badgeValue = [NSString stringWithFormat:@"%d",[self.workOrder.phase.notesArray count]];
    }
    
    // Do any additional setup after loading the view.
    
    //Get the singleton instance
    _currentUser = [AiMCurrentUser shareUser];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)unwindToTabView:(UIStoryboardSegue *)segue
{
    if ([segue.identifier isEqualToString:@"saveToDetail"]){
        AiMAddActionViewController *source = [segue sourceViewController];
        self.action = source.actionToAdd;
        if (self.action != nil) {
            //add to sync queue
            [_currentUser.user.syncQueue addObject:self.action];
            
            //add to actions log
            //[self.workOrder.phase.actionsLog addObject:self.action];
            //[((AiMWorkOrder*)_currentUser.workOrders[self.workOrderIndex]).phase.actionsLog addObject:self.action];
            
            /*
             for (AiMWorkOrder *printWorkOrder in currentUser.workOrders){
             NSLog(@"Work Order %@ - Phase actions log is: %@", printWorkOrder.taskID, ((AiMAction*)printWorkOrder.phase.actionsLog).name);
             NSLog(@"  ");
             }
             */
        }
  
        //Test
        for (int i = 0; i < [_currentUser.user.syncQueue count]; i++)
        {
            NSLog(@"syncQueue time: %@", [(AiMAction *)[_currentUser.user.syncQueue objectAtIndex:i] time]);
        }
        NSLog(@"-----");
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AiMAddActionViewController *vc = [segue destinationViewController];
    vc.workOrder = self.workOrder;
}


@end
