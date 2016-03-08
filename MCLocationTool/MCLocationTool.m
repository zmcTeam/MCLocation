//
//  MCLocationTool.m
//  MCLocationTool
//
//  Created by ZMC on 16/3/7.
//  Copyright © 2016年 Zmc. All rights reserved.
//

#import "MCLocationTool.h"
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
@interface MCLocationTool()
{
    CLLocationManager *_manager;
}
@end

@implementation MCLocationTool
/**
 *  懒加载地图
 */
+ (id) sharedGpsManager {
    static MCLocationTool*_tool=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tool=[[MCLocationTool alloc]init];
    });
    return _tool;
}
- (id)init {
    self = [super init];
    if (self) {
        // 打开定位 然后得到数据
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        if (IOS_VERSION >= 8.0) {
            [_manager requestWhenInUseAuthorization];
            [_manager requestAlwaysAuthorization];
        }
        else{
            [_manager startUpdatingLocation];
        }
    }
    return self;
}

- (void) startLoaction:(void(^)( NSString*cityName))cityName{
    if ([CLLocationManager locationServicesEnabled] == FALSE) {
        NSLog(@"定位开关被关了,请打开");
        return;
    }
    self.getCityName=cityName;
    // 停止上一次的
    [_manager stopUpdatingLocation];
    // 开始新的数据定位
    [_manager startUpdatingLocation];
}
+(void)startLocation:(void (^)(NSString *))cityName{
    [[MCLocationTool sharedGpsManager] startLoaction:cityName];
}


- (void) stop {
    [_manager stopUpdatingLocation];
}
+ (void) stop {
    [[MCLocationTool sharedGpsManager] stop];
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"等待用户授权");
    }else if (status == kCLAuthorizationStatusAuthorizedAlways ||
              status == kCLAuthorizationStatusAuthorizedWhenInUse)
        
    {
        NSLog(@"授权成功");
        
    }else
    {
        NSLog(@"授权失败");
    }
}
// 每隔一段时间就会调用
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    for (CLLocation *loc in locations) {
        CLGeocoder*geocoder=[[CLGeocoder alloc]init];
        [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            for (CLPlacemark*place in placemarks) {
                NSLog(@"城市=%@",place.administrativeArea);
                if (self.getCityName) {
                    self.getCityName(place.administrativeArea);
                }
            }
            
        }];
    }
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位失败");
}
@end
