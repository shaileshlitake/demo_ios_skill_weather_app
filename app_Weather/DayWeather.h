//
//  DayWeather.h
//  app_Weather
//
//  Created by Wipro on 11/05/17.
//  Copyright © 2017 Wipro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DayWeather : NSObject

//weather description
@property (nonatomic, strong) NSString *descriptionString;
@property (nonatomic, copy) NSString *icon;
// temperature
@property (nonatomic, strong) NSString *temp;
@property (nonatomic, strong) NSString *temp_min;
@property (nonatomic, strong) NSString *temp_max;

@property (nonatomic, strong) NSString *humidity;
@property (nonatomic, strong) NSString *pressure;

// date string
@property (nonatomic, copy) NSString *dt_txt;
@property (nonatomic, copy) NSString *day;
@property (nonatomic, copy) NSString *time;

// date string converted into NSDate format for comparison purpose
@property (nonatomic, copy) NSDate *date;

@property(nonatomic,strong)NSString *strDate;

@property(nonatomic,strong)NSString *cloudiness;

@end
