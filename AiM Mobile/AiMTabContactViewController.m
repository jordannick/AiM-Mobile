//
//  AiMTabContactViewController.m
//  AiM Mobile
//
//  Created by norredm on 7/30/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import "AiMTabContactViewController.h"
#import "AiMTabBarViewController.h"

@interface AiMTabContactViewController ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *phone;
@property (weak, nonatomic) IBOutlet UIButton *email;
@property (weak, nonatomic) IBOutlet UILabel *organization;
@property (weak, nonatomic) IBOutlet UILabel *organizationNum;


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
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadInitialData];
}

-(void)loadInitialData
{
    AiMTabBarViewController *parentVc = (AiMTabBarViewController*)[self tabBarController];
    self.currentUser = parentVc.currentUser;
    self.workOrder = parentVc.workOrder;
    
    self.name.text = self.workOrder.organization.contactName;
    self.phone.titleLabel.text = (NSString*)self.workOrder.organization.contactPhone;
    self.email.titleLabel.text = self.workOrder.organization.contactEmail;
    self.organization.text = self.workOrder.organization.name;
    //self.organizationNum.text = self.workOrder.organization
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
