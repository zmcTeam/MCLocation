//
//  ViewController.m
//  MCLocationTool
//
//  Created by ZMC on 16/3/7.
//  Copyright © 2016年 Zmc. All rights reserved.
//

#import "ViewController.h"
#import "MCLocationTool.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    __block  BOOL isOnece = YES;
    [MCLocationTool startLocation:^(NSString *cityName) {
        NSLog(@"city=%@",cityName);
    }];
    if (!isOnece) {
        [MCLocationTool stop];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
