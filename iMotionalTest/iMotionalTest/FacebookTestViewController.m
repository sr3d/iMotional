//
//  FacebookTestViewController.m
//  iMotionalTest
//
//  Created by Manjula Jonnalagadda on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FacebookTestViewController.h"
#import "JSON.h"

@interface FacebookTestViewController()
-(void)connectToFacebook;
-(void)getMe;
@end

@implementation FacebookTestViewController


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(5, 5, 150, 50)];
    [btn setTitle:@"Connect to FB" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(connectToFacebook) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    label=[[UILabel alloc]initWithFrame:CGRectMake(5, 60, 150, 50)];
    label.text=@"Connect to facebook";
    label.adjustsFontSizeToFitWidth=YES;
    [self.view addSubview:label];
    UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(5, 200, 150, 50)];
    [btn1 setTitle:@"Get Me" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(getMe) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)connectToFacebook{
    label.text=@"Connecting to Facebook";
    FacebookServer *fbServer=[FacebookServer facebookServer];
    fbServer.delegate=self;
    [fbServer signintoFacebook];
//    NSLog(@"Connect to facebook");
}
-(void)getMe{
    label.text=@"Getting Me";
    FacebookServer *fbServer=[FacebookServer facebookServer];
    fbServer.delegate=self;
    [fbServer getMeObject];
}
-(void)signedIntoFacebook{
    label.text=@"Connected to Facebook";
}
-(void)postCompleted{
    
}
-(void)postingFailed{
    
}
-(void)gotMe:(NSDictionary *)usr{
    label.text=[usr objectForKey:@"name"];
    SBJsonWriter *jsonWriter=[SBJsonWriter new];
    NSString *jsonString=[jsonWriter stringWithObject:usr];
    NSLog(@"JSON String is %@",jsonString);
    NSLog(@"usr is %@",[usr description]);
}
@end
