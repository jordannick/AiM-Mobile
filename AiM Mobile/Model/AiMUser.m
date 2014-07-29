//
//  AiMUser.m
//  AiM Mobile
//
//  Created by Nick on 7/22/14.
//  Copyright (c) 2014 Oregon State University. All rights reserved.
//

#import "AiMUser.h"
#import "AiMNote.h"


@implementation AiMUser

@synthesize session = _session;

- (NSURLSession *)session
{
    //NSURLSession *session;
    if(!_session)
    {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    }
    return _session;
}


- (NSMutableArray *)workOrders
{
    if(!_workOrders)
    {
        _workOrders = [[NSMutableArray alloc] init];
    }
    return _workOrders;
}

- (NSMutableArray *)syncQueue
{
    if(!_syncQueue)
    {
        _syncQueue = [[NSMutableArray alloc] init];
    }
    return _syncQueue;
}


- (BOOL) addWorkOrder:(AiMWorkOrder *)newWorkOrder
{
    [self.workOrders addObject:newWorkOrder];
    return YES;
}

-(void)syncWorkOrders
{
    //Send each workOrder object in syncQueue to server.
    
    for (int i = 0; i < [self.syncQueue count]; i++) {
        AiMAction *action = self.syncQueue[i];
        //Call push function to save actions to server.
    }
    //Clear syncQueue
    [self.syncQueue removeAllObjects];
}

-(void)sendRequestTo:(NSURL*)url withLoginBool:(BOOL)login andSender:(id)sender
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    NSURLSessionDataTask *getDataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *readableData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"Data: %@\nResponse: %@\nError: %@", readableData, response.URL, error);
        
        
        NSError *jsonParsingError = nil;
        NSArray *arrayWorkOrders = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
        
        
        NSUInteger count = [arrayWorkOrders count];
        
       // NSMutableArray *workOrderIDs = [[NSMutableArray alloc] init];
        //Grab each work order from the array
                //Create an workOrder/Phase object(s) and add them to User
        
        for(int i = 0; i < count; i++)
        {
            NSDictionary *workOrder = [arrayWorkOrders objectAtIndex:i];
            
            NSString *proposalNum = [workOrder objectForKey:@"proposal"];
            NSString *phaseNum = [workOrder objectForKey:@"sort_code"];
            
          //  workOrderIDs[i] = [NSString stringWithFormat:@"%@-%@", proposalNum, phaseNum];
            
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://apps-webdev.campusops.oregonstate.edu/robechar/portal/aim/api/1.0.0/getWorkOrder/%@-%@", proposalNum, phaseNum]];
            
            if (i == (count - 1)) {
                [self getWorkOrderPhase:url withProposalNum:proposalNum withPhaseNum:phaseNum andSender:sender andLastBool:YES];
            } else {
                [self getWorkOrderPhase:url withProposalNum:proposalNum withPhaseNum:phaseNum andSender:sender andLastBool:NO];
            }
        }
        
        //NSLog(@"This is JSON : %@", [innerWorkOrder class]);
        
        //NSLog(@"Test for priCode 1 = %@",[innerWorkOrder objectForKey:@"pri_code"]);
        
//        //Set Organization object
//        AiMOrganization *organization = [[AiMOrganization alloc] init];
//        organization.name = [workOrder objectForKey:@"department"];
//        organization.requestor = [workOrder objectForKey:<#(id)#>]
//        
//        
//        //Set Phase objects
//        
//        //Set Work Order object
        
        //NSLog(@"ALL KEYS: %@",[json allKeys]);
        
        //if(login)
            //[sender segueToOverviewTable];
        //else
            //[sender refreshTable];
    }];
    [getDataTask resume];
}


-(void)getWorkOrderPhase:(NSURL*)url withProposalNum:(NSString*)proposalNum withPhaseNum:(NSString*)phaseNum andSender:(id)sender andLastBool:(BOOL)isLast
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    //NSError *jsonParsingError = nil;
    NSURLSessionDataTask *getDataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        NSDictionary *workOrderPhase = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        AiMWorkOrder *workOrder = [[AiMWorkOrder alloc] init];
        workOrder.taskID = [NSString stringWithFormat:@"%@-%@", proposalNum, phaseNum];
        workOrder.category = [workOrderPhase objectForKey:@"Category"];
        workOrder.building = [workOrderPhase objectForKey:@"Building"];
        workOrder.roomNum = [workOrderPhase objectForKey:@"Room"];
        workOrder.description = [workOrderPhase objectForKey:@"description"];
        workOrder.createdBy = [workOrderPhase objectForKey:@"ent_clerk"];
        workOrder.dateCreated = [workOrderPhase objectForKey:@"Created Date"];
        workOrder.customerRequest = [workOrderPhase objectForKey:@"WO_doc_no"];
        workOrder.type = [workOrderPhase objectForKey:@"order_type"];
        
        AiMOrganization *organization = [[AiMOrganization alloc] init];
        organization.name = [NSString stringWithFormat:@"%@ (%@)",[workOrderPhase objectForKey:@"oc_o"], [workOrderPhase objectForKey:@"department"]];
        organization.requestor = [workOrderPhase objectForKey:@"WO_requestor"];
        organization.contactName = [workOrderPhase objectForKey:@"WO_contact"];
        organization.contactEmail = [workOrderPhase objectForKey:@"WO_contact_mc"];
        organization.contactPhone = [workOrderPhase objectForKey:@"WO_contact_ph"];
        
        workOrder.organization = organization;
        
       // [[workOrderPhase objectForKey:@"phases"] count];
        NSMutableArray *workOrderNotes = [[NSMutableArray alloc] init];
        NSArray *notes = [workOrderPhase objectForKey:@"notes"];
        
        for (int i = 0; i<[notes count]; i++)
        {
            NSDictionary *noteDict = notes[i];
            AiMNote *note = [[AiMNote alloc] init];
            note.noteID = [noteDict objectForKey:@"id"];
            note.note = [noteDict objectForKey:@"notes"];
            note.author = [noteDict objectForKey:@"edit_clerk"];
            note.date = [noteDict objectForKey:@"edit_date"];
        
            [workOrderNotes addObject:note];
        }
        
        
        AiMWorkOrderPhase *phase = [[AiMWorkOrderPhase alloc] init];
        NSArray *phases = [workOrderPhase objectForKey:@"phases"];
        
        for (int i = 0; i < [phases count]; i++)
        {
            NSDictionary *phaseDict = phases[i];
            if ([[phaseDict objectForKey:@"sort_code"] isEqualToString:phaseNum])
            {
                phase.description = [phaseDict objectForKey:@"description"];
                phase.building = [phaseDict objectForKey:@"building"];
                phase.roomNum = [phaseDict objectForKey:@"loc_code"];
                phase.createdBy = [phaseDict objectForKey:@"ent_clerk"];
             //   phase.funding = [phaseDict objectForKey:@""];
                phase.shop = [phaseDict objectForKey:@"shop"];
                phase.dateCreated = [phaseDict objectForKey:@"ent_date"];
                phase.dateEdited = [phaseDict objectForKey:@"edit_date"];
                phase.estStart = [phaseDict objectForKey:@"beg_dt"];
                phase.estEnd = [phaseDict objectForKey:@"end_dt"];
                phase.priority = [phaseDict objectForKey:@"pri_code"];
              //  phase.workCodeGroup = [phaseDict objectForKey:@""];
                phase.workCode = [phaseDict objectForKey:@"craft_code"];
                
                
                phase.notesArray = workOrderNotes;
                
                workOrder.phase = phase;
                
                break;
            
            }
            
        }
        
        [self.workOrders addObject:workOrder];
        
        
        if (isLast)
            [sender segueToOverviewTable];
 
        
        
//       
//        @property(strong, nonatomic) NSString *description;
//        @property(strong, nonatomic) NSString *createdBy;
//        @property(strong, nonatomic) NSString *funding;
//        @property(strong, nonatomic) NSString *shop;
//        @property(strong, nonatomic) NSString *location;
//        @property(strong, nonatomic) NSDate *dateCreated;
//        @property(strong, nonatomic) NSDate *estStart;
//        @property(strong, nonatomic) NSDate *estEnd;
//        @property(strong, nonatomic) NSString *priority;
//        @property(strong, nonatomic) NSString *workCodeGroup;
//        @property(strong, nonatomic) NSString *workCode;
//
        
        
    }];
    [getDataTask resume];
                                        
    
    
    
    
}
/*
 
 initial request to get the SET of WorkOrders               --CALLED ON LOGIN
 
 refresh WorkOrders                                         --CALLED ON ButtonPress or Other
 
 addActions                                                 --CALLED ON SYNC
 
 
 
 
 
 
 
 */

-(void)updateLastLogin
{
    self.lastLogin = [NSDate date];
}



@end
