            # APParser - Class to handle JSON/XML parsing in Objective C
------------------------------------------------------------------------------------------

    Created & tested on : XCODE 6.2

    The aim of this class to avoid wriring repeat code and focus on core development.

    Before you start using APParser Class, you will need to configure the following things in .M file:

  @ Required - 
  
        base_url          -  DEFINE YOUR BASE URL
 
        base_host         -  DEFINE YOUR BASE HOST (For Soap)

 @ Optional

        userNameString    - DEFINE YOUR USERNAME ( in case URL requires authentication, this parameter will be used in NSUrl's Did receive authentication)
 
        passwordString    - DEFINE YOUR PASSWORD ( in case URL requires authentication, this parameter will be used in NSUrl's Did receive authentication)
 
        timeOutInt        - DEFINE YOUR DEFAULT TIMEOUT IN SECONDS default set to 100

------------------------------------------------------------------------------------------
   
        Example Usage:

    1.  Create an Object of the class ( This can created only once in your DID LOAD )

        APPaser * parser = [APParser sharedParser];

        // Register for delegate

        parser.delegate = self;
 
    2.  Prepare your required parameters

       a.  NSString* methodName = @"Your method name";
       b.  NSDictionary* parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:"yourName","username","yourPassword","password"];

    3. call the required Function and add parametrs to it


        Eg: [self parseJsonUsingGetWithMethodName:methodName andParameterDictionary:parameterDict];

    4. Receive the response in Delegate Method

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
 
 
 
 

 
 
 
 
