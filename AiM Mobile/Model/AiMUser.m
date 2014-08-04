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
        
        NSString *param0 = [NSString stringWithFormat:@"%@",action.workOrderID];
        NSString *param1 = action.note;
        NSString *param2 = action.name;
        NSString *param3 = action.time;
        
        //Call push function to save actions to server.
        //call specific online API functions to push sync queue data
        
        
//        NSURL *url = [NSURL URLWithString:@"www.example.com/api/updateFunction"];
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//        //NSData *data = [SOMETHINGSYNCQUEUE dataUsingEncoding:NSUTF8StringEncoding];
//        //request.HTTPBody = data;
//        request.HTTPMethod = @"PUT";
//        
//        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
//        NSURLSessionDataTask *postDataTask = [_currentUser.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//            
//            if (!error){}
//            else {}
//            
//        }];
        

        
        
    }
    //Clear syncQueue
    [self.syncQueue removeAllObjects];
}

-(void)sendRequestTo:(NSURL*)url withLoginBool:(BOOL)login andSender:(id)sender
{
    url = [[NSBundle mainBundle] URLForResource:@"CLARKEM" withExtension:@"txt"];//test local data
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    NSURLSessionDataTask *getDataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //NSString *readableData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"Data: %@\nResponse: %@\nError: %@", readableData, response.URL, error);
        NSError *jsonParsingError = nil;
        NSArray *arrayWorkOrders = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
        
        NSUInteger count = [arrayWorkOrders count];
        count = 3;
        self.completionCount = 0;
        for(int i = 0; i < count; i++)
        {
            NSDictionary *workOrder = [arrayWorkOrders objectAtIndex:i];
            NSString *proposalNum = [workOrder objectForKey:@"proposal"];
            NSString *phaseNum = [workOrder objectForKey:@"sort_code"];
            
            //NSLog(@"%d workDict: %@", i, workOrder);
           // NSLog(@"%d proptest: %@", i, proposalNum);
            
           //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://apps-webdev.campusops.oregonstate.edu/robechar/portal/aim/api/1.0.0/getWorkOrder/%@-%@", proposalNum, phaseNum]];
            
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"158270-001" withExtension:@"txt"];//test local data
           
            
            
            if (i == (count - 1)) {
                [self getWorkOrderPhase:url withProposalNum:proposalNum andPhaseNum:phaseNum andSender:sender andLastBool:YES];
            } else {
                [self getWorkOrderPhase:url withProposalNum:proposalNum andPhaseNum:phaseNum andSender:sender andLastBool:NO];
            }

        }
    }];
    [getDataTask resume];
}


-(void)getWorkOrderPhase:(NSURL*)url withProposalNum:(NSString*)proposalNum andPhaseNum:(NSString*)phaseNum andSender:(id)sender andLastBool:(BOOL)isLast
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    //NSError *jsonParsingError = nil;
    NSURLSessionDataTask *getDataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        NSDictionary *workOrderPhase = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        NSDateFormatter *dfAlt = [[NSDateFormatter alloc] init];
        [dfAlt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        //Initialize workOrder obj
        AiMWorkOrder *workOrder = [[AiMWorkOrder alloc] init];
        workOrder.taskID = [NSString stringWithFormat:@"%@-%@", proposalNum, phaseNum];
        workOrder.category = [workOrderPhase objectForKey:@"Category"];
        workOrder.building = [workOrderPhase objectForKey:@"Building"];
        workOrder.roomNum = [workOrderPhase objectForKey:@"Room"];
        workOrder.description = [workOrderPhase objectForKey:@"description"];
        workOrder.createdBy = [workOrderPhase objectForKey:@"ent_clerk"];
        NSLog(@"dateCreated : %@", [workOrderPhase objectForKey:@"Created Date"]);
        workOrder.dateCreated = [dfAlt dateFromString:[workOrderPhase objectForKey:@"Created Date"]];
        NSLog(@"workOrder.dateCreated : %@", workOrder.dateCreated);
        workOrder.customerRequest = [workOrderPhase objectForKey:@"WO_doc_no"];
        workOrder.type = [workOrderPhase objectForKey:@"order_type"];
        
        //Initialize organization obj
        AiMOrganization *organization = [[AiMOrganization alloc] init];
        organization.name = [NSString stringWithFormat:@"%@ (%@)",[workOrderPhase objectForKey:@"oc_o"], [workOrderPhase objectForKey:@"department"]];
        organization.requestor = [workOrderPhase objectForKey:@"WO_requestor"];
        organization.contactName = [workOrderPhase objectForKey:@"WO_contact"];
        organization.contactEmail = [workOrderPhase objectForKey:@"WO_contact_mc"];
        organization.contactPhone = [workOrderPhase objectForKey:@"WO_contact_ph"];
        workOrder.organization = organization;
        
       //Collect associated notes with workOrder
        NSMutableArray *workOrderNotes = [[NSMutableArray alloc] init];
        NSArray *notes = [workOrderPhase objectForKey:@"notes"];
        
        for (int i = 0; i<[notes count]; i++)
        {
            NSDictionary *noteDict = notes[i];
            AiMNote *note = [[AiMNote alloc] init];
            note.noteID = [noteDict objectForKey:@"id"];
            note.note = [noteDict objectForKey:@"notes"];
            note.author = [noteDict objectForKey:@"edit_clerk"];
            note.date = [df dateFromString:[noteDict objectForKey:@"edit_date"]];
        
            [workOrderNotes addObject:note];
        }
        
        AiMWorkOrderPhase *phase = [[AiMWorkOrderPhase alloc] init];
        //Initialize phase obj
        NSArray *phases = [workOrderPhase objectForKey:@"phases"];
        
        for (int i = 0; i < [phases count]; i++)
        {
            NSDictionary *phaseDict = phases[i];
            if ([[phaseDict objectForKey:@"sort_code"] isEqualToString:phaseNum])
            {
                //phase.estStart = [df dateFromString:[phaseDict objectForKey:@"beg_dt"]];
                //phase.estEnd = [df dateFromString:[phaseDict objectForKey:@"end_dt"]];
                phase.description = [phaseDict objectForKey:@"description"];
                phase.building = [phaseDict objectForKey:@"building"];
                phase.roomNum = [phaseDict objectForKey:@"loc_code"];
                phase.createdBy = [phaseDict objectForKey:@"ent_clerk"];
                phase.shop = [phaseDict objectForKey:@"shop"];
                phase.dateCreated = [df dateFromString:[phaseDict objectForKey:@"ent_date"]];
                phase.dateEdited = [df dateFromString:[phaseDict objectForKey:@"edit_date"]];
                phase.priority = [phaseDict objectForKey:@"pri_code"];
                phase.priorityID = [self assignPriorityID:phase.priority];
                phase.workCode = [phaseDict objectForKey:@"craft_code"];
                phase.notesArray = workOrderNotes;
                workOrder.phase = phase;
                break;
            }
        }
        [self.workOrders addObject:workOrder];
        
        NSLog(@"work order list is: %@", self.workOrders);
        self.completionCount++;
        
        
        
       // if (isLast)
        if (self.completionCount == 3)
            [sender segueToOverviewTable];
   
    }];
    [getDataTask resume];
}

-(NSNumber *)assignPriorityID:(NSString *)priority
{
   // int priorityID;
    if ([priority isEqualToString:@"TIME SENSITIVE"])
        return @0;
    else if ([priority isEqualToString:@"URGENT"])
        return @1;
    else if ([priority isEqualToString:@"ROUTINE"])
        return @2;
    else if ([priority isEqualToString:@"SCHEDULED"])
        return @3;
    else
        return @4;
    

   // return priorityID;
}


-(void)updateLastLogin
{
    self.lastLogin = [NSDate date];
}



@end
