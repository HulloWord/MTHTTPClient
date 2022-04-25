//
//  MTViewController.m
//  MTHTTPClient
//
//  Created by Tom on 09/02/2021.
//  Copyright (c) 2021 Tom. All rights reserved.
//

#import "MTViewController.h"
#import <MTHTTPClient/MTHTTPClientHeader.h>

#import "MTWeatherApi.h"
#import "MTWeatherNetworkConfigruation.h"
@interface MTViewController ()

@end

@implementation MTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
 
}


- (IBAction)requestWeather:(id)sender {
    
    [[MTHTTPClient sharedInstance] requestWithAPI:MTWeatherApi.new andConfiguration:MTWeatherNetworkConfigruation.new completion:^(id<MTHTTPRequestResponseProtocol>  _Nullable response) {
            
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
