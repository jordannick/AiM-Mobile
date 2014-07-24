//
//  AiMWorkOrderDetailViewController.m
//  AiM Mobile
//
//  Created by norredm on 7/23/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import "AiMWorkOrderDetailViewController.h"

#import "AiMAddActionViewController.h"

@interface AiMWorkOrderDetailViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) AiMAction *action;

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

- (void)loadInitialData
{
    //Set all labels to workOrder.value
    NSLog(@"This is workOrder : %@", self.workOrder);
    
    
}
- (IBAction)contactInfoButton:(id)sender
{
    //Create new modal view and display additional contact information.
    
    
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
