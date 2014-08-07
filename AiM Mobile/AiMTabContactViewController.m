//
//  AiMTabContactViewController.m
//  AiM Mobile
//
//  Created by norredm on 8/5/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import "AiMTabContactViewController.h"
#import "AiMCurrentUser.h"
#import "AiMUser.h"
#import "AiMWorkOrder.h"
#import "AiMTabBarViewController.h"

@interface AiMTabContactViewController ()
@property (strong, nonatomic) AiMCurrentUser *currentUser;
@property (strong, nonatomic) AiMWorkOrder *workOrder;
@property (strong, nonatomic) UIAlertView *alertView;

@end

@implementation AiMTabContactViewController

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
    NSLog(@"XXX TEST!!");
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [self loadInitialData];
}

-(void)loadInitialData
{
//    _currentUser = [AiMCurrentUser shareUser];
//    _currentUser.user = [[AiMUser alloc] init];
    
    AiMTabBarViewController *parentVc = (AiMTabBarViewController*)[self parentViewController];
    self.workOrder = parentVc.workOrder;
    
    NSLog(@"%@, %@, %@, %@, %@, %@", self.workOrder.organization.requestor, self.workOrder.organization.name, self.workOrder.phase.requestMethod, self.workOrder.organization.contactPhone, self.workOrder.organization.contactEmail, self.workOrder.organization.contactName);
    
    self.requestor.text = self.workOrder.organization.requestor;
    self.orgName.text = self.workOrder.organization.name;
    if((id)self.workOrder.phase.requestMethod != [NSNull null]){
        self.method.text = self.workOrder.phase.requestMethod;
    }
    
    NSString *phoneString = [NSString stringWithFormat:@"  %@", self.workOrder.organization.contactPhone];
    NSString *emailString = [NSString stringWithFormat:@"  %@", self.workOrder.organization.contactEmail];
    
    self.phone.titleLabel.text = phoneString;
    self.email.titleLabel.text = emailString;
    self.contactName.text = self.workOrder.organization.contactName;
    
    [self.phone setTitle:phoneString forState:UIControlStateNormal];
    [self.phone setTitle:phoneString forState:UIControlStateSelected];
    [self.phone setTitle:phoneString forState:UIControlStateHighlighted];
    [self.email setTitle:emailString forState:UIControlStateNormal];
    [self.email setTitle:emailString forState:UIControlStateSelected];
    [self.email setTitle:emailString forState:UIControlStateHighlighted];
    

    
    NSLog(@"ContactName: %@  vs Requestor:  %@", self.workOrder.organization.contactName, self.workOrder.organization.requestor);
    NSLog(@"FINISHED THAT!");
}
- (IBAction)phoneButton:(id)sender {
    [self.alertView setTitle:@"Call Phone"];
    [self.alertView show];
    
    
    /*
     
     [self.actionConfirmAlert setTitle:[NSString stringWithFormat:@"Work Order %@", self.workOrder.taskID]];
     [self.actionConfirmAlert setMessage:[NSString stringWithFormat:@"Are you sure you want to add this action?:\n%@, %@", self.actionTaken, self.actionTime]];
     
     [self.actionConfirmAlert show];
     
     */
}
- (IBAction)emailButton:(id)sender {
    
    [self.alertView setTitle:@"Send E-Mail"];
    [self.alertView show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
