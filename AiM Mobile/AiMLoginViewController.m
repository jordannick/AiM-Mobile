//
//  AiMLoginViewController.m
//  AiM Mobile
//
//  Created by Nick on 7/22/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import "AiMLoginViewController.h"
#import "AiMWorkOrderTableViewController.h"
#import "AiMWorkOrder.h"
#import "AiMUser.h"
#import "SSKeychain.h"
#include <stdlib.h>

#define AUTH_URL @"http://httpbin.org"


@interface AiMLoginViewController () <NSURLSessionDelegate, NSURLSessionDataDelegate>


@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *errorTextLabel;


@end

@implementation AiMLoginViewController

- (NSMutableArray *)receivedWorkOrders
{
    //NSLog(@"!!!!!!!Setting recievedWorkOrders... %@", _receivedWorkOrders);
    if(!_receivedWorkOrders)
    {
        //NSLog(@"!!!!!!!Setting recievedWorkOrders...");
        _receivedWorkOrders = [[NSMutableArray alloc] init];
    }
    return _receivedWorkOrders;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) getWorkOrdersJSON
{
    //Get JSON from http
    
    
    //Call segue, passing JSON to AiMOverviewTableController
    

}
- (IBAction)loginButton:(id)sender
{
    if([self.usernameTextField.text length] > 0 && [self.passwordTextField.text length] > 0)
    {
        NSLog(@"username/password field OK");
        [self authenticateUser:self.usernameTextField.text withPassword:self.passwordTextField.text];
    }else
    {
        if([self.usernameTextField.text length] == 0 && [self.passwordTextField.text length] ==0)
            self.errorTextLabel.text = @"Please enter username and password";
        else if([self.usernameTextField.text length] == 0)
            self.errorTextLabel.text = @"Please enter username";
        else if([self.passwordTextField.text length] == 0)
            self.errorTextLabel.text = @"Please enter password";
        
    }
    
    
    
}



- (void)authenticateUser:(NSString *)username withPassword:(NSString *)password
{
    NSString *userDataString = [NSString stringWithFormat:@"username=%@password=%@", username, password];
    
    NSURL *url = [NSURL URLWithString:AUTH_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data = [userDataString dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = data;
    request.HTTPMethod = @"POST";
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //[sessionConfiguration setHTTPAdditionalHeaders:@{@"Accept":@"application/json"}];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    //session.delegate = [NSOperationQueue mainQueue];

    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //NSLog(@"Reponse recieved! Data: %@, Response: %@, Error: %@", data, response, error);
        if(!error)
        {
            NSLog(@"User authenticated. Retrieving work orders... %@", data);
            
            // TODO: set recievedWorkOrders
            //for loop adding each workOrder object to array
            //self.receivedWorkOrders
            for(int i = 0; i < 10; i++)
            {
                AiMWorkOrder *newWorkOrder = [[AiMWorkOrder alloc] init];
                int r = rand() % 1000;
                
                newWorkOrder.taskID = [NSNumber numberWithInt:r];
                newWorkOrder.category = @"TestCategory";
                newWorkOrder.description = @"Test Description";
                newWorkOrder.createdBy = @"Kevin";
                newWorkOrder.dateCreated = [NSDate date];
                newWorkOrder.customerRequest = @12;
                newWorkOrder.type = @"1";
                newWorkOrder.organization = [[AiMOrganization alloc] init];
                newWorkOrder.phase = [[AiMWorkOrderPhase alloc] init];
                
                
                
                
                //NSLog(@"Work order: %@ 1", newWorkOrder.taskID);
                //NSLog(@"Idk what to do %@", self.receivedWorkOrders);
                [self.receivedWorkOrders addObject:newWorkOrder];
                //AiMWorkOrder *test = [self.receivedWorkOrders objectAtIndex:0];
                //NSLog(@"2recievedWorkOrders : %@", test);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                AiMWorkOrderTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WorkOrderTableView"];
                vc.workOrders = self.receivedWorkOrders;
                NSLog(@"Setting vc.workOrders = %@", _receivedWorkOrders);
                [self.navigationController pushViewController:vc animated:NO];
            });
        }else
        {
            //Alert user. Get new user credentials
            self.errorTextLabel.text = @"Invalid username/password";
        }
    }];
    [postDataTask resume];

    
    
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    // Do any additional setup after loading the view.
    
    NSString *service = @"AiM Mobile";
    NSError *error = nil;
    
    NSUserDefaults *appDefaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [appDefaults objectForKey:@"username"];
    if(username)
    {
        NSString *password = [SSKeychain passwordForService:service account:username error:&error];
        if(password)
        {
            [self authenticateUser:username withPassword: password];
        } else
        {
            NSLog(@"Could not retrieve password for username: %@\nERROR: %@", username, error);
        }
    } else
    {
        NSLog(@"No username saved.");
    }
    
    //[self authenticateUser:@"test" withPassword:@"test"];
    

    
//    SSKeychain *keychain = [[SSKeychain alloc] init];
//    NSString *password = [SSKeychain passwordForService:service account:_usernameTextField.text error:&error];
    

    
    
    /*
     Check properties for last user
     
    Check if user info is saved in keychain
    if yes
        send credentials
    else
        prompt user for info
        send credentials
     
     
     if credentials ok
        do getworkerjson http stuff
     else 
        prompt user
     
     
     
     
     
     */
    
    
    
    
}

- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
    NSLog(@"Text field param : %@", textField);
    
    if(textField == self.usernameTextField)
    {
        if([self.passwordTextField.text length] > 0)
        {
            [textField resignFirstResponder];
        }else
        {
            [textField resignFirstResponder];
            [self.passwordTextField becomeFirstResponder];
        }
    }else if(textField == self.passwordTextField)
    {
        if([self.usernameTextField.text length] == 0)
        {
            [textField resignFirstResponder];
            [self.usernameTextField becomeFirstResponder];
        }
        else
        {
            [textField resignFirstResponder];
        }
    }

    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"LoginShowTable"])
    {
        AiMWorkOrderTableViewController *vc = [segue destinationViewController];
    
    }
    
}


@end
