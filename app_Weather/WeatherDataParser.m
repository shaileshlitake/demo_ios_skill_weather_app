//
//  WeatherDataParser.m
//  app_Weather
//
//  Created by Wipro on 11/05/17.
//  Copyright © 2017 Wipro. All rights reserved.
//

#import "WeatherDataParser.h"
#import "DayWeather.h"

@implementation WeatherDataParser


+(CityWeather*)getParsedData:(NSDictionary*)returnedDict{
   
    
    CityWeather *cityWeather = [CityWeather new];
    
    cityWeather.day1Report = [[NSMutableArray alloc] init];
    
    cityWeather.day2Report = [[NSMutableArray alloc] init];
    
    cityWeather.day3Report = [[NSMutableArray alloc] init];
    
    cityWeather.day4Report = [[NSMutableArray alloc] init];
    
    cityWeather.day5Report = [[NSMutableArray alloc] init];
    
    
    NSArray *listOfRecords = [returnedDict objectForKey:@"list"];
    
    NSString *keyPath = [NSString stringWithFormat:@"city.name"];
    
    cityWeather.cityName = [returnedDict valueForKeyPath:keyPath];
    
    keyPath = [NSString stringWithFormat:@"city.coord.lat"];
    
    cityWeather.cityLatitude = [returnedDict valueForKeyPath:keyPath];
    
    keyPath = [NSString stringWithFormat:@"city.coord.lon"];
    
    cityWeather.cityLongitude = [returnedDict valueForKeyPath:keyPath];
    
    if (listOfRecords.count) {
        
        for (NSDictionary *listRecord in listOfRecords) {
            
            NSArray *dateArray = [[listRecord objectForKey:@"dt_txt"] componentsSeparatedByString:@" "];
            
            NSString *strdate = [dateArray objectAtIndex:0];
            
            NSString *time = [dateArray objectAtIndex:1];
            
            DayWeather *aRecord = [[DayWeather alloc] init];
            
            aRecord.strDate = strdate;
            
            aRecord.time = time;
            
            aRecord.cloudiness = [[NSString alloc] initWithFormat:@"%@%% cloudiness",[[listRecord objectForKey:@"clouds"] objectForKey:@"all"]];
            
            aRecord.humidity = [[NSString alloc] initWithFormat:@"%@%% humidity",[[listRecord objectForKey:@"main"] objectForKey:@"humidity"]];
            
            aRecord.descriptionString = [[NSString alloc] initWithFormat:@"%@ weather",[[[listRecord objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"description"]];
            
            aRecord.temp = [[NSString alloc] initWithFormat:@"%@ ºC",[[listRecord objectForKey:@"main"] objectForKey:@"temp"]];
            
            aRecord.temp_min = [[NSString alloc] initWithFormat:@"%@ ºC",[[listRecord objectForKey:@"main"] objectForKey:@"temp_min"]];
        
               aRecord.temp_max = [[NSString alloc] initWithFormat:@"%@ ºC",[[listRecord objectForKey:@"main"] objectForKey:@"temp_max"]];
            
            aRecord.pressure = [[NSString alloc] initWithFormat:@"%@ ºC",[[listRecord objectForKey:@"main"] objectForKey:@"pressure"]];
            
            if (cityWeather.day1Report.count == 0) {
                [cityWeather.day1Report addObject:aRecord];
            }else{
                if ([[((DayWeather *)[cityWeather.day1Report objectAtIndex:0]) strDate] isEqualToString:strdate ]) {
                    [cityWeather.day1Report addObject:aRecord];
                }else{
                    if (cityWeather.day2Report.count == 0) {
                        [cityWeather.day2Report addObject:aRecord];
                    }else{
                        if ([[((DayWeather *)[cityWeather.day2Report objectAtIndex:0]) strDate] isEqualToString:strdate ]) {
                            [cityWeather.day2Report addObject:aRecord];
                        }else{
                            if (cityWeather.day3Report.count == 0) {
                                [cityWeather.day3Report addObject:aRecord];
                            }else{
                                if ([[((DayWeather *)[cityWeather.day3Report objectAtIndex:0]) strDate] isEqualToString:strdate])
                                {
                                    [cityWeather.day3Report addObject:aRecord];
                                }else{
                                    if (cityWeather.day4Report.count == 0) {
                                        [cityWeather.day4Report addObject:aRecord];
                                    }else{
                                        if ([[((DayWeather *)[cityWeather.day4Report objectAtIndex:0]) strDate] isEqualToString:strdate]) {
                                            [cityWeather.day4Report addObject:aRecord];
                                        }else{
                                            if (cityWeather.day5Report.count == 0) {
                                                [cityWeather.day5Report addObject:aRecord];
                                            }else{
                                                if ([[((DayWeather *)[cityWeather.day5Report objectAtIndex:0]) strDate] isEqualToString:strdate]) {
                                                    [cityWeather.day5Report addObject:aRecord];
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    
    return cityWeather;
}


+(void)setDayRecordsWith:(NSDictionary *)receivedData
{
    
}




@end
