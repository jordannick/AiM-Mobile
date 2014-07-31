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


@interface AiMLoginViewController () <NSURLSessionDelegate, NSURLSessionDataDelegate, UITextFieldDelegate, NSURLSessionTaskDelegate>


@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *usernameTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *activityIndicatorLabel;

@property (strong, nonatomic)  NSURLProtectionSpace *loginProtectionSpace;

@property (strong, nonatomic) NSURLSession *session;

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


- (void) getWorkOrdersJSON
{
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


- (void)segueToOverviewTable
{
    dispatch_async(dispatch_get_main_queue(), ^{
        AiMWorkOrderTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WorkOrderTableView"];
        vc.currentUser = self.currentUser;
        NSLog(@"Segueing now to next VC");
        [self.navigationController pushViewController:vc animated:NO];
    });
}


- (void)authenticateUser:(NSString *)username withPassword:(NSString *)password
{
    self.backButton.hidden = YES;
    self.loginButton.hidden = YES;
    
    NSString *aimUser = self.usernameTextField.text;
    //if([aimUser isEqualToString:@"t"])
        aimUser = @"CLARKEM";
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", @"http://apps-webdev.campusops.oregonstate.edu/robechar/portal/aim/api/1.0.0/getWorkOrders/", aimUser];
    
    [_currentUser sendRequestTo:[NSURL URLWithString:urlString] withLoginBool: YES andSender: self];
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


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"This textField: %@, started editing...", textField);
}


- (IBAction)unwindToLoginView:(UIStoryboardSegue *)segue
{
    NSLog(@"segue: %@", segue.identifier);
    [self removeUserCredential];

    
}



@end
