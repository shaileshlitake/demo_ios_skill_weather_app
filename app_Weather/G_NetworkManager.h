//
//  G_NetworkManager.h
//  app_Weather
//
//  Created by Wipro on 11/05/17.
//  Copyright © 2017 Wipro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface G_NetworkManager : NSObject

+(instancetype)sharedNetworkHandlerManager;

-(void)getWeatherDataWithSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;


@end
