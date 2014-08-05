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
@property (weak, nonatomic) IBOutlet UIButton *loginButton;


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


-(BOOL)validateInput:(UITextField*)textField
{
    //Initialize animation
    CAKeyframeAnimation * jiggleAnim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
    jiggleAnim.values = @[ [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f) ], [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f) ] ] ;
    jiggleAnim.autoreverses = YES;  jiggleAnim.repeatCount = 2.0f;  jiggleAnim.duration = 0.07f;
    
    if([textField.text length] == 0){
        UIColor *color = [UIColor colorWithRed:1 green:0.165 blue:0.165 alpha:.5];
        [textField.layer addAnimation:jiggleAnim forKey:nil];
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName: color}];
        return NO;
    }else{
        return YES;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    
    NSLog(@"View Will Appear");
}
-(void)viewDidLayoutSubviews
{
    //NSLog(@"Old frame = %@"
    
    CGFloat labelHeight = self.usernameTextField.frame.size.height;
    CGRect oldFrame = self.loginButton.frame;
    NSLog(@"viewDidLayoutSubviews");
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if(orientation == 3 || orientation == 4){
        NSLog(@"Landscape!");
        
        CGPoint loginButtonOrigin = self.loginButton.frame.origin;
        NSLog(@"origin: X:%f Y:%f", loginButtonOrigin.x, loginButtonOrigin.y);
        
        NSLog(@"LANDSCAPE Width: %f and Height: %f", self.view.frame.size.width, self.view.frame.size.height);
        
        CGFloat loginButtonWidth = self.view.frame.size.width - self.usernameTextField.frame.origin.x*3 - self.usernameTextField.frame.size.width;
        
        CGFloat diff = (self.passwordTextField.frame.origin.y + labelHeight) - self.usernameTextField.frame.origin.y;
        CGFloat loginYPosition = self.usernameTextField.frame.origin.y + (diff/2) - labelHeight/2;
        CGFloat loginXPosition = self.usernameTextField.frame.origin.x*2 + self.usernameTextField.frame.size.width;
        [self.loginButton setFrame:CGRectMake(loginXPosition, loginYPosition, loginButtonWidth, labelHeight)];
        NSLog(@"X: %f  Y: %f  %f", loginXPosition, loginYPosition, labelHeight);
        
    }else{
        self.loginButton.frame = oldFrame;
        NSLog(@"PORTRAIT Width: %f and Height: %f", self.view.frame.size.width, self.view.frame.size.height);
    }
    NSLog(@"Orientation: %d", orientation);
    
    self.loginButton.layer.cornerRadius = 20;
    //self.loginButton.layer.borderWidth = 1;
    //self.loginButton.layer.borderColor = [[UIColor blackColor] CGColor];
    
    CAGradientLayer *loginButtonGradient = [AiMBackground lightBlueGradient];
    [loginButtonGradient setFrame:self.loginButton.bounds];
    [loginButtonGradient setBounds:self.loginButton.bounds];
    [self.loginButton.layer insertSublayer:loginButtonGradient atIndex:0];
    //[self.loginButton setNeedsDisplay];
    
    NSLog(@"gradientFrame:  X: %f Y:  %f  loginFrame:  X:  %f  Y:  %f", loginButtonGradient.frame.origin.x, loginButtonGradient.frame.origin.y, self.loginButton.frame.origin.x, self.loginButton.frame.origin.y);
    
    
    [self.loginButton setNeedsDisplay];
    [self.loginButton setNeedsLayout];
}

-(void)transitionInputTo:(NSString*)position
{
    CGFloat yField = self.usernameTextField.layer.position.y;
    CGFloat frameWidth = self.view.frame.size.width;
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if(orientation == 3 || orientation == 4)
    {
        frameWidth = self.view.frame.size.height;
    }
    if([position isEqualToString:@"right"]) frameWidth = frameWidth*-1;     //If RIGHT, reverse direction
    
    [UIView animateWithDuration:0.5 animations:^{
        self.usernameTextField.layer.position = CGPointMake(self.usernameTextField.layer.position.x - frameWidth, yField);
        
        self.passwordTextField.layer.position = CGPointMake(self.passwordTextField.layer.position.x - frameWidth, yField);
        
    }];

}
- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
    
    if(textField == self.usernameTextField){
        if([self validateInput:textField]){
            [textField resignFirstResponder];
            [self.passwordTextField becomeFirstResponder];
        }
    }else if(textField == self.passwordTextField){
        if([self validateInput:textField]){
            [textField resignFirstResponder];
            [self authenticateUser:self.usernameTextField.text withPassword:self.passwordTextField.text];
        }
    }
    return YES;

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
    //self.loginButton.hidden = YES;
    [self.loginButton setEnabled:NO];
    
    NSString *aimUser = self.usernameTextField.text;
    //if([aimUser isEqualToString:@"t"])
    //aimUser = @"CLARKEM";
    //aimUser = @"BROOKESR";
    //aimUser = @"BROWNN";
    //aimUser = @"CROSST";
    aimUser = @"DEBAUWB";
    NSString *urlString = [NSString stringWithFormat:@"%@%@", @"http://apps-webdev.campusops.oregonstate.edu/robechar/portal/aim/api/1.0.0/getWorkOrders/", aimUser];
    
    [_currentUser sendRequestTo:[NSURL URLWithString:urlString] withLoginBool: YES andSender: self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"Started running");
    //[self testOnline];
    
    [self.usernameTextField becomeFirstResponder];
    
    UIImage *myImage = [UIImage imageNamed:@"osubackground.png"];
    //UIImage *myImage = [UIImage imageNamed:@"valleyBg.png"];
    
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [gaussianBlurFilter setDefaults];
    [gaussianBlurFilter setValue:[CIImage imageWithCGImage:[myImage CGImage]] forKey:kCIInputImageKey];
    [gaussianBlurFilter setValue:@5 forKey:kCIInputRadiusKey];
    
    CIImage *outputImage = [gaussianBlurFilter outputImage];
    CIContext *context   = [CIContext contextWithOptions:nil];
    CGRect rect          = [outputImage extent];
    
    // these three lines ensure that the final image is the same size
    
    rect.origin.x        += (rect.size.width  - myImage.size.width ) / 2;
    rect.origin.y        += (rect.size.height - myImage.size.height) / 2;
    rect.size            = myImage.size;
    
    CGImageRef cgimg     = [context createCGImage:outputImage fromRect:rect];
    UIImage *blurredImage       = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    
    
    
    
    
    UIImageView *loginBackground = [[UIImageView alloc] initWithImage:blurredImage];
    
    
    CGFloat bgWidth = loginBackground.frame.size.width;
    CGFloat bgHeight = loginBackground.frame.size.height;
    CGFloat xOffset = (bgWidth - self.view.frame.size.width)/2;
    
    
    [loginBackground setFrame:CGRectMake(-xOffset, 0, bgWidth, bgHeight)];
    [self.view insertSubview:loginBackground atIndex:0];
    
    [self getWorkOrdersJSON];
    
    CAGradientLayer *bgLayer = [AiMBackground blueGradient];
    bgLayer.frame = self.view.bounds;
    CGFloat max = MAX(bgLayer.frame.size.height, bgLayer.frame.size.width);
    bgLayer.frame = CGRectMake(bgLayer.frame.origin.x, bgLayer.frame.origin.y, max, max);
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
    
    self.currentState = @"username";
    
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
