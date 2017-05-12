//
//  CityWeather.h
//  app_Weather
//
//  Created by Wipro on 11/05/17.
//  Copyright © 2017 Wipro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DayWeather.h"

@interface CityWeather : NSObject

@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *cityLatitude;
@property (nonatomic, copy) NSString *cityLongitude;
// Holds day and time wise weather data
@property (nonatomic, strong) NSArray <DayWeather *> *weatherData;

@property(nonatomic,strong)NSMutableArray *day1Report;
@property(nonatomic,strong)NSMutableArray *day2Report;
@property(nonatomic,strong)NSMutableArray *day3Report;
@property(nonatomic,strong)NSMutableArray *day4Report;
@property(nonatomic,strong)NSMutableArray *day5Report;




@end
