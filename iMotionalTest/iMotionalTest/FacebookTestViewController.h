//
//  FacebookTestViewController.h
//  iMotionalTest
//
//  Created by Manjula Jonnalagadda on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookServer.h"

@interface FacebookTestViewController : UIViewController<FacebookServerDelegate>{
    UILabel *label;
}

@end
