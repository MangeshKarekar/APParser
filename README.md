# APParser
Parsing Class for JSON/XML in Objective C

Created & tested on : XCODE 6.2

The aim for coding this class to simplify parsing and focus on core development.

Before you use the Class You will need to configure the following things in .M file:

  @required - 
  
 base_url          -  DEFINE YOUR BASE URL
 
 base_host         -  DEFINE YOUR BASE HOST (For Soap)

 @ Optional

 userNameString    - DEFINE YOUR USERNAME ( in case URL requires authentication, this parameter will be used in NSUrl's Did receive authentication)
 
 passwordString    - DEFINE YOUR PASSWORD ( in case URL requires authentication, this parameter will be used in NSUrl's Did receive authentication)
 
 timeOutInt        - DEFINE YOUR DEFAULT TIMEOUT IN SECONDS default set to 100

Example Usage:

// Create an Object of the class ( This can created only once in your DID LOAD )
 APPaser * parser = [APParser sharedParser];
 // Register for delegate
 parser.delegate = self;
 
 // Prepare Dictiony with required parametrs
 NSString* methodName = @"Your method name";
 NSString* soapAction = @"Your soap action"
 NSDictionary* parameterDict = {username:USERNAME,password:PASSWORD}
 // Send the dictionary to the desired function
[self parseSoapWithJSONSoapContents:[NSDictionary dictionaryWithObjectAndKeys:methodName,@"methodName",soapAction,@"soapAction",parameterDict,@"parameterDict",nil];

// These above two steps can also be combined into one !!!

// Receive the response in Delegate Method :

// for Json
-(void)receiveJsonResponse:(NSDictionary *)responseDict withSuccess:(BOOL)successBool;
// for XML
-(void)receivedXmlResponse:(NSArray*)responseArray andSuccess:(BOOL)success;

If parsing is successful, the success BOOl will be true else it it will be false.

I have tried to make the process as stable as possible and I retun the success BOOL as FALSE in following circumtances:

 1. IN CASE THE CONNECTION FAILS TO CONNECT WITH THE URL
 2. AUTHENTICATION FAILS IN 'didReceiveAuthenticationChallenge'
 3. NSURL CONNECTION FAILS IN 'didFailWithError'
 4. IF NO PARAMETERS ARE RECEIVED IN 'connectionDidFinishLoading'



Changes, suggestions are Welcome :)

Mangesh
 
 
 
 
