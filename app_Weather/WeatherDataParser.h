//
//  WeatherDataParser.h
//  app_Weather
//
//  Created by Wipro on 11/05/17.
//  Copyright © 2017 Wipro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityWeather.h"

@interface WeatherDataParser : NSObject

// We are holding all data in one object for the lat and long we are sending.
+(CityWeather*)getParsedData:(NSDictionary*)returnedDict;
+(void)setDayRecordsWith:(NSDictionary *)receivedData;

@end
