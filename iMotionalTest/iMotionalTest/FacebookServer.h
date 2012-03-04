//
//  FacebookServer.h
//  FacebookTest
//
//  Created by Manjula Jonnalagadda on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Facebook.h"

@class FacebookServer;

@protocol FacebookServerDelegate <NSObject>

@optional

-(void)signedIntoFacebook;
-(void)postingCompleted;
-(void)postingFailed;
-(void)signedOutOfFacebook;
-(void)SigningIntoFacebookCancelled;
-(void)facebookSessionInvalidated;
-(void)gotMe:(NSDictionary *)usr;

@end

@interface FacebookServer : NSObject<FBSessionDelegate,FBRequestDelegate>{
    Facebook *_facebook;
    __weak id<FacebookServerDelegate> _delegate;
    NSArray *delegates;
}
@property(strong,nonatomic)Facebook *facebook;
@property(weak,nonatomic)id<FacebookServerDelegate> delegate;

+(FacebookServer *)facebookServer;
-(void)signintoFacebook;
-(void)signOutFacebook;
-(void)postToFacebook;
-(void)getMeObject;
@end
