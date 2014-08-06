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
        //AiMAction *action = self.syncQueue[i];
        
        /*
        NSString *param0 = [NSString stringWithFormat:@"%@",action.workOrderID];
        NSString *param1 = action.note;
        NSString *param2 = action.name;
        NSString *param3 = action.time;
         */
        
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
    url = [[NSBundle mainBundle] URLForResource:@"DEBAUWB" withExtension:@"txt"];//test local data
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    NSURLSessionDataTask *getDataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //NSString *readableData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"Data: %@\nResponse: %@\nError: %@", readableData, response.URL, error);
        NSError *jsonParsingError = nil;
        NSArray *arrayWorkOrders = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
        
        self.count = [arrayWorkOrders count];
        //if (self.count > 20)
        //    self.count = 20;
        self.count = 7;
        self.completionCount = 0;
        for(int i = 0; i < self.count; i++)
        {
            NSDictionary *workOrder = [arrayWorkOrders objectAtIndex:i];
            NSString *proposalNum = [workOrder objectForKey:@"proposal"];
            NSString *phaseNum = [workOrder objectForKey:@"sort_code"];
            
            //NSLog(@"%d workDict: %@", i, workOrder);
           // NSLog(@"%d proptest: %@", i, proposalNum);
            
          // NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://apps-webdev.campusops.oregonstate.edu/robechar/portal/aim/api/1.0.0/getWorkOrder/%@-%@", proposalNum, phaseNum]];

            //test local data
            NSURL *url;
            switch (i) {
                case 0:
                    url = [[NSBundle mainBundle] URLForResource:@"158270-001" withExtension:@"txt"];
                    break;
                case 1:
                    url = [[NSBundle mainBundle] URLForResource:@"157283-002" withExtension:@"txt"];
                    break;
                case 2:
                    url = [[NSBundle mainBundle] URLForResource:@"148773-002" withExtension:@"txt"];
                    break;
                case 3:
                    url = [[NSBundle mainBundle] URLForResource:@"152982-002" withExtension:@"txt"];
                    break;
                case 4:
                    url = [[NSBundle mainBundle] URLForResource:@"160551-001" withExtension:@"txt"];
                    break;
                case 5:
                    url = [[NSBundle mainBundle] URLForResource:@"158270-001" withExtension:@"txt"];
                    break;
                case 6:
                    url = [[NSBundle mainBundle] URLForResource:@"148773-002" withExtension:@"txt"];
                    break;
                default:
                    break;
            }
            //end test
           
            [self getWorkOrderPhase:url withProposalNum:proposalNum andPhaseNum:phaseNum andSender:sender];

        }
    }];
    [getDataTask resume];
}


-(void)getWorkOrderPhase:(NSURL*)url withProposalNum:(NSString*)proposalNum andPhaseNum:(NSString*)phaseNum andSender:(id)sender
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
                if (![[phaseDict objectForKey:@"beg_dt"] isKindOfClass:[NSNull class]]){
                    phase.estStart = [df dateFromString:[phaseDict objectForKey:@"beg_dt"]];
                }
                if (![[phaseDict objectForKey:@"end_dt"] isKindOfClass:[NSNull class]]){
                    phase.estEnd = [df dateFromString:[phaseDict objectForKey:@"end_dt"]];
                }
                
                phase.description = [phaseDict objectForKey:@"description"];
                phase.building = [phaseDict objectForKey:@"building"];
                phase.roomNum = [phaseDict objectForKey:@"loc_code"];
                phase.createdBy = [phaseDict objectForKey:@"ent_clerk"];
                phase.shop = [phaseDict objectForKey:@"shop"];
                phase.dateCreated = [df dateFromString:[phaseDict objectForKey:@"ent_date"]];
                phase.dateEdited = [df dateFromString:[phaseDict objectForKey:@"edit_date"]];
                phase.priority = [phaseDict objectForKey:@"pri_code"];
                phase.priorityID = [self assignPriorityID:phase.priority];
                phase.priorityColor = [self assignPriorityColor:phase.priority];
                phase.workCode = [phaseDict objectForKey:@"craft_code"];
                phase.notesArray = workOrderNotes;
                workOrder.phase = phase;
                break;
            }
        }
        [self.workOrders addObject:workOrder];
        
        NSLog(@"work order list is: %@", self.workOrders);
        self.completionCount++;
        
        
    
        if (self.completionCount == self.count)
            [sender segueToOverviewTable];
   
    }];
    [getDataTask resume];
}

-(NSNumber *)assignPriorityID:(NSString *)priority
{
   // int priorityID;
    if ([priority isEqualToString:@"EMERGENCY"])
        return @0;
    else if ([priority isEqualToString:@"TIME SENSITIVE"])
        return @1;
    else if ([priority isEqualToString:@"URGENT"])
        return @2;
    else if ([priority isEqualToString:@"ROUTINE"])
        return @3;
    else if ([priority isEqualToString:@"SCHEDULED"])
        return @4;
    else
        return @5;
    

   // return priorityID;
}
-(UIColor*)assignPriorityColor:(NSString *)priority
{
    
    if ([priority isEqualToString:@"EMERGENCY"])
        return [UIColor colorWithRed:0.906 green:0.298 blue:0.235 alpha:1];
    else if ([priority isEqualToString:@"TIME SENSITIVE"])
        return [UIColor colorWithRed:0.953 green:0.792 blue:0.153 alpha:1];
    else if ([priority isEqualToString:@"URGENT"])
        return [UIColor colorWithRed:0.973 green:0.58 blue:0.024 alpha:1];
    else if ([priority isEqualToString:@"ROUTINE"])
        return [UIColor colorWithRed:0.149 green:0.651 blue:0.357 alpha:1];
    else if ([priority isEqualToString:@"SCHEDULED"])
        return [UIColor colorWithRed:0.145 green:0.455 blue:0.663 alpha:1];
    else
        return [UIColor blackColor];
    
}

-(void)updateLastLogin
{
    self.lastLogin = [NSDate date];
}



@end
