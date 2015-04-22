//
//  APParser.h
//
//
//  Created by Mangesh Karekar.
//
//

// *********    PLEASE READ THIS *********

/*
 
 *********  BASE CONFIGURATION REQUIREMNTS *********
 
 Please configure these before you start using the class in .M
 
 @ REQUIRED
 
 base_url          -  DEFINE YOUR BASE URL
 
 base_host         -  DEFINE YOUR BASE HOST (For Soap)
 
 
 @ OPTIONAL

 userNameString    - DEFINE YOUR USERNAME ( in case URL requires authentication, this parameter will be used in NSUrl's Did receive authentication)
 
 passwordString    - DEFINE YOUR PASSWORD ( in case URL requires authentication, this parameter will be used in NSUrl's Did receive authentication)
 
 timeOutInt        - DEFINE YOUR DEFAULT TIMEOUT IN SECONDS default set to 100
 
 
 *****  DEFAULT RESPONSE FROM CALLING ALL THESE FUNCTIONS IS IN NSDictionary EXCEPT FOR XML PARSING*****
 
 
 */


#import <Foundation/Foundation.h>

@protocol APParserDelegate <NSObject>

@optional

-(void)receiveJsonResponse:(NSDictionary *)responseDict withSuccess:(BOOL)successBool;
-(void)receivedXmlResponse:(NSArray*)responseArray andSuccess:(BOOL)success;

@end


@interface APParser : NSObject<NSXMLParserDelegate,NSURLConnectionDataDelegate,APParserDelegate>{
   
    // Common Parameters
    
    NSMutableData* webData;
    NSURLConnection *theConnection;


    // parameters for xml
    int operations;
    int maxCount;
    NSString* currentElementString;
    NSArray* elementNamesArray;
    NSMutableDictionary* parsedXmlDictionary;
    NSString* foundCharacterString;
    NSMutableArray* parsedXmlArray;

    
    // delegate
    
    id <APParserDelegate>delegate;
    
    // parameters for JSON

    BOOL isJson;
    
    
}

@property (strong,nonatomic) id <APParserDelegate>delegate;


+(APParser*) sharedParser;


#pragma mark SOAP Functions

/*
 
THIS FUNCTIONS PARSE USING SOAP - JSON.
 
 ********    RESPONSE IN RETURENED IN DICTIONARY FORMAT *********
 
 ******REQUIREMENTS********
 
 THESE FUNCTIONS REQUIRE THE FOLOWING ELEMENTS IN DICTIONARY FORMAT
 
 1. METHONAME: AS KEY - 'methodName' - this method name will be combined with the base url to form a URL
 2. SOAPACTION AS KEY - 'soapAction'
 3. PARAMETER DICTIONARY TO SEND AS KEY - 'parameterDict' - these parameters will be concverted to NSData and attached to the URLRequest as HTTPBODY
 
 
 Eg: {
 
 methodName : @"Your method name"
 
 soapAction : @"Your soap action"
 
 parameterDict : {username:YOUR USERNAME,password: YOUR PASSWORD}
 
 }
 

 
 ******EXPECTED RESULT********
 
    CALL THE DELEAGATE METHODS 'receiveJsonResponse' FOR JSON and 'receiveXMLResponse' for XML.
 
 
    CHECK FOR 'successBool' : if 'true' then parsing is succesfull and if  'false' then parsing is unsuccesful and dictionay is NULL.
 
    I AM CHECKING FOR ERRORS TO CALL 'successBool' UNDER FOLLOWING SCENARIOS:
 
 1. IN CASE THE CONNECTION FAILS TO CONNECT WITH THE URL
 2. AUTHENTICATION FAILS IN 'didReceiveAuthenticationChallenge'
 3. NSURL CONNECTION FAILS IN 'didFailWithError'
 4. IF NO PARAMETERS ARE RECEIVED IN 'connectionDidFinishLoading'
 
 
*/

-(void)parseSoapWithJSONSoapContents:(NSDictionary*)soapDict;


/*
 
 THIS FUNCTIONS PARSE USING SOAP - XML.
 
 ********    RESPONSE IN RETURENED IN ARRAY(containing dictionaries) FORMAT *********
 
 ******REQUIREMENTS********
 
 THESE FUNCTIONS REQUIRE THE FOLOWING ELEMENTS IN DICTIONARY FORMAT
 
 1. METHONAME: AS KEY - 'methodName' - this method name will be combined with the base url to form a URL
 2. SOAPACTION AS KEY - 'soapAction'
 3. PARAMETER DICTIONARY TO SEND AS KEY - 'parameterDict' - these parameters will be concverted to NSData and attached to the URLRequest as HTTPBODY
 
 
 Eg: {
 
 methodName : @"Your method name"
 
 soapAction : @"Your soap action"
 
 parameterDict : {username:YOUR USERNAME,password: YOUR PASSWORD}
 
 elementNamesArray : (Array containing header values to catch)
 
 }
 
 
 
 ******EXPECTED RESULT********
 
 CALL THE DELEAGATE METHODS 'receiveJsonResponse' FOR JSON and 'receiveXMLResponse' for XML.
 
 
 CHECK FOR 'successBool' : if 'true' then parsing is succesfull and if  'false' then parsing is unsuccesful and dictionay is NULL.
 
 I AM CHECKING FOR ERRORS TO CALL 'successBool' UNDER FOLLOWING SCENARIOS:
 
 1. IN CASE THE CONNECTION FAILS TO CONNECT WITH THE URL
 2. AUTHENTICATION FAILS IN 'didReceiveAuthenticationChallenge'
 3. NSURL CONNECTION FAILS IN 'didFailWithError'
 4. IF NO PARAMETERS ARE RECEIVED IN 'connectionDidFinishLoading'
 
 
 */

-(void)parseSoapWithXMLwithSoapContents:(NSDictionary*)soapDict;



#pragma mark JSON functions

// JSON - GET

/*
 
 THIS FUNCTION PARSE USING GET - JSON .
 
 ******REQUIREMENTS********
 
 THESE FUNCTIONS REQUIRE THE FOLOWING ELEMENTS IN DICTIONARY FORMAT
 
 1. METHONAME: AS KEY - 'methodName' - this method name will be combined with the base url to form a URL
 2. PARAMETER DICTIONARY TO APPEND TO THE URL - 'parameterDict' - these parameters will be added to the URL to form final GET URL. the 'key' parameter is base parameter and 'value' parameter is value.
 
 
    Eg: {
 
        methodName : @"Your method name"
 
        parameterDict : {username:YOUR USERNAME,password: YOUR PASSWORD}
 
        }
 
 
 
 
 ******EXPECTED RESULT********
 
 CALL THE DELEAGATE METHODS 'receiveJsonResponse' FOR JSON and 'receiveXMLResponse' for XML.
 
 CHECK FOR 'successBool' : if 'true' then parsing is succesfull and if  'false' then parsing is unsuccesful and dictionay is NULL.
 
 I AM CHECKING FOR ERRORS TO CALL 'successBool' UNDER FOLLOWING SCENARIOS:
 
 1. IN CASE THE CONNECTION FAILS TO CONNECT WITH THE URL
 2. AUTHENTICATION FAILS IN 'didReceiveAuthenticationChallenge'
 3. NSURL CONNECTION FAILS IN 'didReceiveAuthenticationChallenge'
 4. IF NO PARAMETERS ARE RECEIVED IN 'connectionDidFinishLoading'
 
 */


-(void)parseJsonWithGetAndContents:(NSDictionary*)jsonDict;



// JSON - POST

/*
 
 THIS FUNCTION PARSE USING GET - JSON .

 ******REQUIREMENTS********
 
 THIS FUNCTION REQUIRES THE FOLOWING ELEMENTS IN DICTIONARY FORMAT
 
 1. METHONAME: AS KEY - 'methodName' - this method name will be combined with the base url to form a URL
 2. PARAMETER DICTIONARY TO SEND AS KEY - 'parameterDict' - these parameters will be concverted to NSData and attached to the URLRequest as HTTPBODY
 
 
    Eg: {
 
            methodName : @"Your method name"
 
            parameterDict : {username:YOUR USERNAME,password: YOUR PASSWORD}
 
        }

 
 
 ******EXPECTED RESULT********
 
 CALL THE DELEAGATE METHOD 'receiveJsonResponse'
 
 CHECK FOR 'successBool' : if 'true' then parsing is succesfull and if  'false' then parsing is unsuccesful and dictionay is NULL.


*/

-(void)parsePostJsonWithContents:(NSDictionary*)jsonDict;



// JSON - GET (USING HEADER)
/*
 ******REQUIREMENTS********
 
 THIS FUNCTION REQUIRES THE FOLOWING ELEMENTS IN DICTIONARY FORMAT
 
 1. METHONAME: AS KEY - 'methodName' - this method name will be combined with the base url to form a URL
 2. PARAMETER DICTIONARY TO SEND AS HEADER - 'parameterDict' - the 'key' will be Header Field and 'value' will be value to send
 
 
 
    Eg: {
 
            methodName : @"Your method name"
 
            parameterDict : {username:YOUR USERNAME,password: YOUR PASSWORD}
 
        }
 

 ******EXPECTED RESULT********
 
 CALL THE DELEAGATE METHOD 'receiveJsonResponse'
 
 CHECK FOR 'successBool' : if 'true' then parsing is succesfull and if  'false' then parsing is unsuccesful and dictionay is NULL.
 
 
 */


-(void)parseJsonWithGetUsingHeaderValues:(NSDictionary*)jsonDict;




#pragma mark OTHER functions

// Function to cancel the NSUrl request

-(void)cancelConnection;








@end
