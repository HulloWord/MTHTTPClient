//
//  MTViewController.m
//  MTHTTPClient
//
//  Created by Tom on 09/02/2021.
//  Copyright (c) 2021 Tom. All rights reserved.
//

#import "MTViewController.h"
#import <MTHTTPClient/MTHTTPClientHeader.h>
@interface MTViewController ()

@end

@implementation MTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    [[MTHTTPClient sharedInstance].request([MTHTTPRequest requestWithMethod:kMTHTTPMethod_GET url:@"/data/2.5/weather" param:@{@"appid": @"fd5489917aec099715785ebd7593340d", @"q": @"Shenzhen"}]) subscribeNext:^(MTHTTPResponse * data) {
//        NSLog(@"--> %@",data.reqResult);
//        
//    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
