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
#import "AiMBackground.h"
#include <stdlib.h>


#define AUTH_URL @"http://jsonplaceholder.typicode.com/posts"


@interface AiMLoginViewController () <NSURLSessionDelegate, NSURLSessionDataDelegate, UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *usernameTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *activityIndicatorLabel;

@property (strong, nonatomic)  NSURLProtectionSpace *loginProtectionSpace;
//@property (strong, nonatomic) NSString *currentUser;

@property CGPoint startingPosField;
@property CGPoint endingPosField;
@property CGPoint startingPosLabel;
@property CGPoint endingPosLabel;
@property CGPoint hiddenLeftPosLabel;
@property CGPoint hiddenLeftPosField;

@property (strong, nonatomic) NSArray *priorities;
@property (strong, nonatomic) NSString *currentState;

@property (strong, nonatomic) AiMUser *currentUser;

@end

@implementation AiMLoginViewController

/*
- (NSMutableArray *)receivedWorkOrders
{
    if(!_receivedWorkOrders)
    {
        _receivedWorkOrders = [[NSMutableArray alloc] init];
    }
    return _receivedWorkOrders;
}
 */

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (AiMWorkOrderPhasePriority*)createPriorityWithName:(NSString*)name andDescription:(NSString*)description andPriorityID:(NSNumber*)priorityID
{
    AiMWorkOrderPhasePriority *priority = [[AiMWorkOrderPhasePriority alloc] init];
    priority.name = name;
    priority.description = description;
    priority.priorityID = priorityID;
    
    return priority;
}

- (void) getWorkOrdersJSON
{
    self.priorities = [NSArray arrayWithObjects:[self createPriorityWithName:@"URGENT" andDescription:@"Do this quickly" andPriorityID:@0],
    [self createPriorityWithName:@"GENERAL" andDescription:@"Do this regularly" andPriorityID:@1],
     [self createPriorityWithName:@"DAILY" andDescription:@"Do this daily" andPriorityID:@2], nil];
    
    NSLog(@"This is the array... %@", self.priorities);
    //Get JSON from http
    
    
    
    //Call segue, passing JSON to AiMOverviewTableController
    

}
- (IBAction)backButton:(UIButton *)sender {
    NSLog(@"Back Button Pressed! %@", self.currentState);
    [self transitionInputTo:@"right"];
    self.currentState = @"username";
    [self.loginButton setTitle:@"Next" forState:UIControlStateNormal];
    [self.usernameTextField becomeFirstResponder];
    self.backButton.hidden = YES;
}



-(BOOL)validateInput
{
    //Initialize animation
    CAKeyframeAnimation * jiggleAnim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
    jiggleAnim.values = @[ [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f) ], [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f) ] ] ;
    jiggleAnim.autoreverses = YES;  jiggleAnim.repeatCount = 2.0f;  jiggleAnim.duration = 0.07f;
    
    if([self.currentState isEqualToString:@"username"]){        //If username field is showing
        if([self.usernameTextField.text length] == 0){          //If the field is empty
            [self.usernameTextField.layer addAnimation:jiggleAnim forKey:nil];
            [self.usernameTextLabel.layer addAnimation:jiggleAnim forKey:nil];      //jiggle and set to red
            self.usernameTextLabel.textColor = [UIColor redColor];
            return NO;
        }
    }else if([self.currentState isEqualToString:@"password"]){      //If password field is showing
        if([self.passwordTextField.text length] == 0){              //If the field is empty
            [self.passwordTextField.layer addAnimation:jiggleAnim forKey:nil];
            [self.passwordTextLabel.layer addAnimation:jiggleAnim forKey:nil];      //jiggle and set to red
            self.passwordTextLabel.textColor = [UIColor redColor];
            return NO;
        }
    }
    return YES;
    
}

-(void)transitionInputTo:(NSString*)position
{
    CGFloat yField = self.usernameTextField.layer.position.y;
    CGFloat yLabel = self.usernameTextLabel.layer.position.y;
    CGFloat frameWidth = self.view.frame.size.width;
    if([position isEqualToString:@"right"]) frameWidth = frameWidth*-1;     //If RIGHT, reverse direction
    
    [UIView animateWithDuration:0.5 animations:^{
        self.usernameTextField.layer.position = CGPointMake(self.usernameTextField.layer.position.x - frameWidth, yField);
        
        self.passwordTextField.layer.position = CGPointMake(self.passwordTextField.layer.position.x - frameWidth, yField);
        
        self.usernameTextLabel.layer.position = CGPointMake(self.usernameTextLabel.layer.position.x - frameWidth, yLabel);
        self.passwordTextLabel.layer.position = CGPointMake(self.passwordTextLabel.layer.position.x - frameWidth, yLabel);
        
        self.activityIndicatorLabel.layer.position = CGPointMake(self.activityIndicatorLabel.layer.position.x - frameWidth, yLabel);
        self.activityIndicator.layer.position = CGPointMake(self.activityIndicator.layer.position.x - frameWidth, yLabel);
    }];

}
- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
    
    if(textField == self.usernameTextField){
        if([self validateInput]){
            [self transitionInputTo:@"left"];
            [textField resignFirstResponder];
            [self.passwordTextField becomeFirstResponder];
            self.currentState = @"password";
            self.backButton.hidden = NO;
            [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
        }
    }else if(textField == self.passwordTextField){
        if([self validateInput]){
            [self transitionInputTo:@"left"];
            [textField resignFirstResponder];
            [self authenticateUser:self.usernameTextField.text withPassword:self.passwordTextField.text];
        }
    }
    return YES;

}
/*
 
 
 -(void)transitionInputTo:(NSString*)position
        checks state and moves inputs LEFT, RIGHT
 
 
 
 -(BOOL)validateInput
        checks for empty input
        if (invalid)    make red and jiggle
 
 
 return key starts as NEXT. TransitionTo function changes it to GO
 onREturnKeyPress
    validateInput
    if valid
 
 
 */
- (IBAction)loginButton:(id)sender
{
    if([self.currentState isEqualToString:@"username"]){
        if([self validateInput]){
            [self transitionInputTo:@"left"];
            [self.passwordTextField becomeFirstResponder];
            self.currentState = @"password";
            self.backButton.hidden = NO;
            [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
        }
    }else if([self.currentState isEqualToString:@"password"]){
        if([self validateInput]){
            [self transitionInputTo:@"left"];
            [self authenticateUser:self.usernameTextField.text withPassword:self.passwordTextField.text];
        }
    }
    
}
- (void) initProtectionSpace
{
    NSURL *url = [NSURL URLWithString:AUTH_URL];
    self.loginProtectionSpace = [[NSURLProtectionSpace alloc] initWithHost:url.host
                                                                      port:[url.port integerValue]
                                                                  protocol:url.scheme
                                                                     realm:nil
                                                      authenticationMethod:NSURLAuthenticationMethodHTTPDigest];

}

- (void) setUserCredential: (NSString *)username withPassword:(NSString *)password
{
    //Check if username already stored before adding
    NSURLCredential *credential;
    NSDictionary *credentials;
    
    credentials = [[NSURLCredentialStorage sharedCredentialStorage] credentialsForProtectionSpace:self.loginProtectionSpace];
    credential = [credentials objectForKey:username];
    
    //If this username is not already stored
    if (!credential)
    {
        credential = [NSURLCredential credentialWithUser:username password:password persistence:NSURLCredentialPersistencePermanent];
        [[NSURLCredentialStorage sharedCredentialStorage] setCredential:credential forProtectionSpace:self.loginProtectionSpace];
    }

}



- (NSURLCredential *) getUserCredential
{
    //Find and return the first credential found
    
    NSURLCredential *credential;
    NSDictionary *credentials;
    
    credentials = [[NSURLCredentialStorage sharedCredentialStorage] credentialsForProtectionSpace:self.loginProtectionSpace];
    credential = [credentials.objectEnumerator nextObject];
    
    return credential;
}


- (void) removeUserCredential
{
    NSURLCredential *credential;
    NSDictionary *credentials;
    
    credentials = [[NSURLCredentialStorage sharedCredentialStorage] credentialsForProtectionSpace:self.loginProtectionSpace];
    
    //Search if it exists before removing
    credential = [credentials objectForKey:_currentUser.username];
    
    if (credential)
    {
        [[NSURLCredentialStorage sharedCredentialStorage] removeCredential:credential forProtectionSpace:self.loginProtectionSpace];
    } else {
        NSLog(@"Could not find credential to remove");
    }
}





- (void)authenticateUser:(NSString *)username withPassword:(NSString *)password
{

    NSString *userDataString = [NSString stringWithFormat:@"username=%@&password=%@", username, password];
    
    NSURL *url = [NSURL URLWithString:AUTH_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data = [userDataString dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = data;
    request.HTTPMethod = @"POST";
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //[sessionConfiguration setHTTPAdditionalHeaders:@{@"Accept":@"application/json"}];
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    
     _currentUser.session = session;
    //session.delegate = [NSOperationQueue mainQueue];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //NSLog(@"Reponse recieved! Data: %@, Response: %@, Error: %@", data, response, error);

        
        if(!error)
        {
            NSLog(@"Reponse recieved! Data: %@, Response: %@, Error: %@", data, response, error);
            NSString *readableData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Data is: %@", readableData);
            
            NSError *jsonParsingError = nil;
           
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            NSLog(@"json array is: %@", json);
            
            NSLog(@"User authenticated. Retrieving work orders... %@", data);

            //Assume credentials are valid, attempt to store in keychain for future use
           // self.currentUser = username;
            _currentUser.username = username;
            [self setUserCredential:username withPassword:password];

            
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
                
                NSDateComponents* components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:newWorkOrder.dateCreated];
               // newWorkOrder.dateComponents = @[[NSNumber numberWithInt:[components day]], [NSNumber numberWithInt:[components month]] ,[NSNumber numberWithInt:[components year]]];
                
                newWorkOrder.sortDate = [NSString stringWithFormat:@"%d/%d/%d", [components day],[components month],[components year]];
                                                
                newWorkOrder.customerRequest = @12;
                newWorkOrder.type = @"1";
                newWorkOrder.organization = [[AiMOrganization alloc] init];
                newWorkOrder.phase = [[AiMWorkOrderPhase alloc] init];
                
      
                //[[self.receivedWorkOrders addObject:newWorkOrder];
                [_currentUser addWorkOrder:newWorkOrder];
    
            }

            //adding extra test entries
            for(int i = 0; i < 5; i++)
            {
                AiMWorkOrder *newWorkOrder = [[AiMWorkOrder alloc] init];
                int r = rand() % 1000;
                
                newWorkOrder.taskID = [NSNumber numberWithInt:r];
                newWorkOrder.category = @"TestCategory2";
                newWorkOrder.description = @"Test Description2";
                newWorkOrder.createdBy = @"Nick";
                newWorkOrder.dateCreated = [NSDate date];
                
                NSDateComponents* components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:newWorkOrder.dateCreated];
                // newWorkOrder.dateComponents = @[[NSNumber numberWithInt:[components day]], [NSNumber numberWithInt:[components month]] ,[NSNumber numberWithInt:[components year]]];
                
               // newWorkOrder.sortDate = [NSString stringWithFormat:@"%d/%d/%d", [components day],[components month],[components year]];
                newWorkOrder.sortDate = @"12/10/2009";
                
                newWorkOrder.customerRequest = @12;
                newWorkOrder.type = @"1";
                newWorkOrder.organization = [[AiMOrganization alloc] init];
                newWorkOrder.phase = [[AiMWorkOrderPhase alloc] init];
                
                
                //[[self.receivedWorkOrders addObject:newWorkOrder];
                [_currentUser addWorkOrder:newWorkOrder];
                
            }

            

            [self.activityIndicator startAnimating];
            [self.activityIndicator setNeedsDisplay];
            //TODO: remove this
            sleep(1);

            dispatch_async(dispatch_get_main_queue(), ^{
                AiMWorkOrderTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WorkOrderTableView"];
                //vc.workOrders = self.receivedWorkOrders;
               // vc.currentUser = self.currentUser;
                vc.currentUser = self.currentUser;
               // NSLog(@"Setting vc.workOrders = %@", _receivedWorkOrders);
                [self.navigationController pushViewController:vc animated:NO];
            });
        }else
        {
            //Alert user. Get new user credentials
            NSLog(@"Failed to authenticate.");
        }
    }];
    [postDataTask resume];


}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"Started running");
    //[self testOnline];
    
    
    
    [self getWorkOrdersJSON];
    
    CAGradientLayer *bgLayer = [AiMBackground blueGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
    
    self.currentState = @"username";
    self.backButton.hidden = YES;
    
    //self.activityIndicator.layer.opacity = 0.0f;
    //self.activityIndicatorLabel.layer.opacity = 0.0f;
    
    [self.usernameTextField setReturnKeyType:UIReturnKeyNext];
    [self.passwordTextField setReturnKeyType:UIReturnKeyGo];
    //[self.usernameTextField becomeFirstResponder];
    
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    [self initProtectionSpace];
    
    self.passwordTextField.secureTextEntry = YES;
 
    _currentUser = [[AiMUser alloc] init];
   
    

    NSURLCredential *credential = [self getUserCredential];
    
//    if (credential)
//    {
//        NSLog(@"User %@ already connected with password %@", credential.user, credential.password);
//        [self authenticateUser:credential.user withPassword: credential.password];
//
//    } else {
//        NSLog(@"No credentials found.");
//        //Assume user will enter credentials into text fields and press login button
//    }

    
    
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
        //AiMWorkOrderTableViewController *vc = [segue destinationViewController];
    
    }
    
}





- (IBAction)unwindToLoginView:(UIStoryboardSegue *)segue
{
    NSLog(@"segue: %@", segue.identifier);
    [self removeUserCredential];

    
}



@end
