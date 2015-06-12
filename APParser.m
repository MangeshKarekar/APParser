//
//  APParser.m
//
//
//  Created by Mangesh Karekar 
//  
//

#import "APParser.h"

// BASE DECLARATIONS

// base url

static NSString* base_url = @"";


// base host

static NSString* base_host = @"";


// username & password

static  NSString* userNameString = @"";
static  NSString* passwordString = @"";

// URL TIMEOUT

static int timeOutInt = 100;


static APParser *parserInstance = nil;

@implementation APParser
@synthesize delegate;

// setting singletion class

+ (APParser *) sharedParser{
    @synchronized(self){
        if (parserInstance == nil){
            
            parserInstance = [[APParser alloc] init];
            
        }
    }
    return parserInstance;
}

// setting delegate

- (id) init {
    
    self = [super init];
    if (self)
    {
        //delegate = self;
        self.delegate = self;
        
    }
    return self;
}


#pragma mark PARSE FUNCTIONS
-(void)parseJsonUsingSoapWithMethodName:(NSString*)methodName andSoapAction:(NSString*)soapActionString andParameterDictionary:(NSDictionary*)parameterDict
{
    isJson = YES;
    NSString * base = base_url;
    NSLog(@"soapactionstring - %@",soapActionString);
    NSLog(@"parameter dict - %@",parameterDict);
    NSError* error = nil;
    NSString* finalUrlString = [base stringByAppendingString:methodName];
    NSURL* finalUrl = [NSURL URLWithString:finalUrlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:finalUrl
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:timeOutInt];
    [request addValue: soapActionString forHTTPHeaderField:@"SOAPAction"];
    [request addValue:base_host forHTTPHeaderField:@"Host"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameterDict options:kNilOptions error:&error];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]];
    [request addValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: jsonData];
    theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if( theConnection)
    {
        webData = [NSMutableData data];
    }else
    {
        [delegate receiveJsonResponse:NULL withSuccess:NO];
    }
}
-(void)parseJsonUsingGetWithMethodName:(NSString*)methodName andParameterDictionary:(NSDictionary*)parameterDict
{
   // NSError* error = nil;
    isJson = YES;
    NSString* urlString;
    NSString* finalUrlString;
    NSString* parameterString = @"";
    urlString = [NSString stringWithFormat:@"%@%@&",base_url,methodName];
    // append final URL string
    NSArray* keysArray = [parameterDict allKeys];
    NSString*  lastObjectString = [keysArray lastObject];
    for (int counter =0; counter< keysArray.count; counter++)
    {
        NSString* tempString;
        if ([lastObjectString isEqualToString:[keysArray objectAtIndex:counter]])
        {
            tempString = [NSString stringWithFormat:@"%@=%@",[keysArray objectAtIndex:counter],[parameterDict objectForKey:[keysArray objectAtIndex:counter]]];
        }else
        {
            tempString = [NSString stringWithFormat:@"%@=%@&",[keysArray objectAtIndex:counter],[parameterDict objectForKey:[keysArray objectAtIndex:counter]]];
        }
      parameterString = [NSString stringWithFormat:@"%@%@",parameterString,tempString];
    }
    // join the URL
    finalUrlString = [NSString stringWithFormat:@"%@%@",urlString,parameterString];
    NSURL * finalUrl = [NSURL URLWithString:finalUrlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:finalUrl
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:timeOutInt];
    [request addValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];
    theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if( theConnection)
    {
        webData = [NSMutableData data];
        
    }else
    {
        [delegate receiveJsonResponse:NULL withSuccess:NO];
    }
}



-(void)parseJsonUsingPostWithMethodName:(NSString*)methodName andParameterDictionary:(NSDictionary*)parameterDict
{
    NSError* error = nil;
    isJson = YES;
    NSString* finalUrlString = [NSString stringWithFormat:@"%@%@",base_url,methodName];
    NSURL* finalUrl = [NSURL URLWithString:finalUrlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:finalUrl
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:timeOutInt];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameterDict options:kNilOptions error:&error];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]];
    [request addValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: jsonData];
    theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if( theConnection)
    {
        webData = [NSMutableData data];
        
    }else
    {
        [delegate receiveJsonResponse:NULL withSuccess:NO];
    }
}

-(void)parseXMLwithSoapWithMethodName:(NSString*)methodName andSoapAction:(NSString*)soapAction andContentType:(NSString*)contentType andElementsToCatchArray:(NSArray*)elementsArray andParametersToSend:(NSDictionary*)parameterDict
{
    // set flag
    isJson = NO;
    // catch the element names array
    elementNamesArray = elementsArray;
    // set max count
    maxCount = (int)elementNamesArray.count;
    // XML parsing prepartion
    NSString * base = base_url;
    NSArray* keysArray = [parameterDict allKeys];
    NSMutableString* requestString = [[NSMutableString alloc]init];
    for (int counter=0; counter<keysArray.count; counter++)
    {
        NSString* stringToJoin;
        if (counter>0)
        {
            stringToJoin = [NSString stringWithFormat:@"&%@=%@",[keysArray objectAtIndex:counter],[parameterDict objectForKey:[keysArray objectAtIndex:counter]]];
        }else
        {
            stringToJoin = [NSString stringWithFormat:@"%@=%@",[keysArray objectAtIndex:counter],[parameterDict objectForKey:[keysArray objectAtIndex:counter]]];
        }
        [requestString appendString:stringToJoin];
    }
    NSString *msgLength = [NSString stringWithFormat:@"%d", (int)[requestString length]];
    NSString* finalUrlString = [base stringByAppendingString:methodName];
    NSURL* finalUrl = [NSURL URLWithString:finalUrlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:finalUrl
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:timeOutInt];
    [request addValue: soapAction forHTTPHeaderField:@"SOAPAction"];
    [request addValue:base_host forHTTPHeaderField:@"Host"];
    [request addValue: contentType forHTTPHeaderField:@"Content-Type"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    NSData *requestData = [NSData dataWithBytes:[requestString UTF8String] length:[requestString length]];
    [request setHTTPBody: requestData];
    theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if( theConnection )
    {
        webData = [NSMutableData data];
    }else {
        NSLog(@"Some error occurred in Connection");
        [delegate receivedXmlResponse:NULL andSuccess:NO];
    }
}

-(void)parseJsonUsingGetWithHeaderValuesWithMethodName:(NSString*)methodName andParameterDictionary:(NSDictionary*)parameterDict
{
    isJson = YES;
    NSString* finalUrlString = [NSString stringWithFormat:@"%@%@",base_url,methodName];
    NSURL* finalUrl = [NSURL URLWithString:finalUrlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:finalUrl
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:timeOutInt];
    [request addValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"GET"];
    // SET HEADER VALUES
    NSArray* keysArray = [parameterDict allKeys];
    for (int counter =0; counter<keysArray.count; counter++)
    {
        [request setValue:[parameterDict objectForKey:[keysArray objectAtIndex:counter]] forHTTPHeaderField:[keysArray objectAtIndex:counter]];
    }
    theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if( theConnection)
    {
        webData = [NSMutableData data];
        
    }else
    {
        [delegate receiveJsonResponse:NULL withSuccess:NO];
    }
}



#pragma mark NSURL DELEGATES
// NSURL CONNECTION DELEGATE
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge previousFailureCount] > 1)
    {
        //  UIAlertView *alertTwo = [[UIAlertView alloc] initWithTitle:@"Authentication Error" message:@"Too many unsuccessul login attempts." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        // [alertTwo show];
        
        if (isJson)
        {
            [delegate receiveJsonResponse:NULL withSuccess:NO];
            
            
        }else
        {
            [delegate receivedXmlResponse:NULL andSuccess:NO];

        }
        
    } else{
        
        NSURLCredential *cred = [[NSURLCredential alloc] initWithUser:userNameString password:passwordString persistence:NSURLCredentialPersistenceForSession] ;
        [[challenge sender] useCredential:cred forAuthenticationChallenge:challenge];
    }
}


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength:0];
    
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error with connection %@",error);
    if (isJson)
    {
        [delegate receiveJsonResponse:NULL withSuccess:NO];

        
    }else
    {
        [delegate receivedXmlResponse:NULL andSuccess:NO];


    }

}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSLog(@"Done. received Bytes %lu", (unsigned long)[webData length]);
    
    
    if (isJson) {
        
        NSArray* returnArray = [NSJSONSerialization JSONObjectWithData:webData  options:kNilOptions error:nil];
        NSLog(@"%@",returnArray);

        NSDictionary* returnDict = [NSJSONSerialization JSONObjectWithData:webData  options:kNilOptions error:nil];
        //NSDictionary* returnDict = [NSJSONSerialization JSONObjectWithData:data  options:0 error:nil];
        NSLog(@"%@",returnDict);
        
        if (returnDict.count ==0 || returnDict == nil || returnDict == NULL)
        {
            [delegate receiveJsonResponse:NULL withSuccess:NO];

        }else
            
            [delegate receiveJsonResponse:returnDict withSuccess:YES];

      //  [delegate receiveJsonResponse:returnDict];
        
    }else
    {
        
        if (webData == nil)
        {
            
            [delegate receivedXmlResponse:NULL andSuccess:NO];

            
        }else
        {
            NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:webData];
            // Don't forget to set the delegate!
            xmlParser.delegate = self;
            
            // Run the parser
            [xmlParser parse];


        }
        
        
        
    }
    
}

// CANCEL NSURL CONNECTION

-(void)cancelConnection
{
    [theConnection cancel];
}

# pragma mark NSXML PARSER DELEGATE
// NSXML PARSER DELEGATE
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    parsedXmlArray = [[NSMutableArray alloc]init];
}

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:
(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    currentElementString = elementName;
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    foundCharacterString = string;
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementNamesArray containsObject:currentElementString])
    {
        NSDictionary * tempDict = [NSDictionary dictionaryWithObjectsAndKeys:foundCharacterString,currentElementString, nil];
        [parsedXmlArray addObject:tempDict];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    // call the delegate
    if (parsedXmlArray.count>0)
    {
        [delegate receivedXmlResponse:[NSArray arrayWithArray:parsedXmlArray] andSuccess:YES];
    }else
    {
        [delegate receivedXmlResponse:nil andSuccess:NO];
    }
}


@end

