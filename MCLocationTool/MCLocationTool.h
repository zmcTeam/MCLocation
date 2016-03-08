//
//  MCLocationTool.h
//  MCLocationTool
//
//  Created by ZMC on 16/3/7.
//  Copyright © 2016年 Zmc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface MCLocationTool : NSObject<CLLocationManagerDelegate>

@property(copy,nonatomic)void(^getCityName)(NSString*cityName);
/**
 *  开启定位
 */
+(void) startLocation:(void(^)( NSString*cityName))cityName;


+ (void) stop;

@end
