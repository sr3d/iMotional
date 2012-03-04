//
//  FacebookServer.m
//  FacebookTest
//
//  Created by Manjula Jonnalagadda on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FacebookServer.h"

@implementation FacebookServer
@synthesize facebook=_facebook;
@synthesize delegate=_delegate;

-(id)init{
    self=[super init];
    if (self) {
        _facebook=[[Facebook alloc]initWithAppId:@"232453153516852" andDelegate:self];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"FBAccessTokenKey"] 
            && [defaults objectForKey:@"FBExpirationDateKey"]) {
            self.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
            self.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        }    }
    return self;
}

+(FacebookServer *)facebookServer{
    static FacebookServer *instance=nil;
    if (instance==nil) {
        instance=[[self alloc]init];
    }
    return instance;
}
-(void)signintoFacebook{
    if (![self.facebook isSessionValid]) {
        NSArray *permissions=[NSArray arrayWithObjects:@"read_stream",@"publish_stream", nil];
        [self.facebook authorize:permissions];
    }else{
        if ([self.delegate respondsToSelector:@selector(signedIntoFacebook)]) {
            [self.delegate signedIntoFacebook];
        }
    }
}
-(void)signOutFacebook{
    [self.facebook logout];
}
- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[self.facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    if ([self.delegate respondsToSelector:@selector(signedIntoFacebook)]) {
        [self.delegate signedIntoFacebook];
    }
    
}
-(void)postToFacebook{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"itunes.com/apps/musicrules" forKey:@"link"];
    [params setObject:@"I completed a course" forKey:@"description"];
    [params setObject:@"Yay!!" forKey:@"caption"];
    [params setObject:@"Music Rules" forKey:@"name"];
    //   [params setObject:[lnk objectForKey:@"icon"] forKey:@"icon"];
    //   [params setObject:[lnk objectForKey:@"picture"] forKey:@"picture"];
    [params setObject:@"I've completed a course in Music Theory" forKey:@"message"];
    //        [self.uploadProgressView setHidden:NO];
    //        [self.uploadProgressView setProgress:0.5];
    [self.facebook requestWithGraphPath:@"me/feed" andParams:params andHttpMethod:@"POST" andDelegate:self];
    
}
-(void)getMeObject{
     [self.facebook requestWithGraphPath:@"/me" andDelegate:self];
}
-(void)requestLoading:(FBRequest *)request{

    NSLog(@"Request is loading");
    
    
}
-(void)request:(FBRequest *)request didLoad:(id)result{
    NSLog(@"Successfully Posted to FB");
    if ([request.httpMethod isEqualToString:@"POST"]) {
        if ([self.delegate respondsToSelector:@selector(postingCompleted)]) {
            [self.delegate postingCompleted];
        }
    }
    if ([request.httpMethod isEqualToString:@"GET"]) {
        if ([[request url] hasSuffix:@"/me"]) {
            NSDictionary* usr = (NSDictionary*)result;
            if ([self.delegate respondsToSelector:@selector(gotMe:)]) {
                [self.delegate gotMe:usr];
            }
            
        }
    }
    
}
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"response received is %@",[response description]);
}
-(void)request:(FBRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"The request failed to load %@",[error localizedDescription]);
}
-(void)fbSessionInvalidated{
    if ([self.delegate respondsToSelector:@selector(facebookSessionInvalidated)]) {
        [self.delegate facebookSessionInvalidated];
    }
}
-(void)fbDidLogout{
    NSLog(@"FB Logged out");
    if ([self.delegate respondsToSelector:@selector(signedOutOfFacebook)]) {
        [self.delegate signedOutOfFacebook];
    }
}
- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt{
    NSLog(@"Token extended");
}
- (void)fbDidNotLogin:(BOOL)cancelled{
    if ([self.delegate respondsToSelector:@selector(SigningIntoFacebookCancelled)]) {
        [self.delegate SigningIntoFacebookCancelled];
    }
}

@end
