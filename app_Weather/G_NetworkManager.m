//
//  G_NetworkManager.m
//  app_Weather
//
//  Created by Wipro on 11/05/17.
//  Copyright © 2017 Wipro. All rights reserved.
//

#import "G_NetworkManager.h"
#import "WeatherDataParser.h"

@implementation G_NetworkManager


static NSString * const kServerTimeOutError = @"Service request timed out.";

static NSString * const kErrorDomain = @"com.wipro.WeatherApp";

static NSString * const kBaseURL = @"http://api.openweathermap.org/data/2.5/forecast?lat=18.5196&lon=73.8553&units=metric&appid=f020f54898ac8b5f5e696ccaa027b749";



+(instancetype)sharedNetworkHandlerManager{
    
    static dispatch_once_t pred = 0;
    
    static id sharedObject = nil;
    
    dispatch_once(&pred, ^{
        sharedObject = [[self alloc] init];
    });
    
    return sharedObject;
}

- (void)getWeatherDataWithSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    NSURL *serviceURL = [NSURL URLWithString:kBaseURL];
    [self downloadDataFromURL:serviceURL withCompletionHandler:^(NSData *data) {
        // Check if any data received.
        if (data != nil) {
            NSError *error;
            NSDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if (error != nil) {
                failure(error);
            }
            else{
                @try{
                    success([WeatherDataParser getParsedData:returnedDict]);
                } @catch (NSException *exception) {
                    NSLog(@"-- Exception -- %@", exception.description);
                    failure(error);
                }
            }
        }
        else{
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:kServerTimeOutError forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kErrorDomain code:9999 userInfo:details];
            failure(error);
        }
    }];
}

-(void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *))completionHandler{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForResource = 30.0;
    configuration.timeoutIntervalForRequest = 30.0;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            completionHandler(nil);
        }
        else{
            NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
            if (HTTPStatusCode != 200) {
                NSLog(@"HTTP status code = %ld", (long)HTTPStatusCode);
            }
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completionHandler(data);
            }];
        }
    }];
    [task resume];
}


@end
