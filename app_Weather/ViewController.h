//
//  ViewController.h
//  app_Weather
//
//  Created by Barclays on 11/05/17.
//  Copyright © 2017 Wipro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReachabilityManager.h"

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

- (void)showAlertViewControllerWithTitle:(NSString*)title andMessage:(NSString*)message;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) Reachability *hostRechable;
@property (nonatomic, strong) Reachability *internetRechable;

@property(nonatomic,weak)IBOutlet UIButton *btnDay1;
@property(nonatomic,weak)IBOutlet UIButton *btnDay2;
@property(nonatomic,weak)IBOutlet UIButton *btnDay3;
@property(nonatomic,weak)IBOutlet UIButton *btnDay4;
@property(nonatomic,weak)IBOutlet UIButton *btnDay5;



-(IBAction)btnDay1Selected:(id)sender;
-(IBAction)btnDay2Selected:(id)sender;
-(IBAction)btnDay3Selected:(id)sender;
-(IBAction)btnDay4Selected:(id)sender;
-(IBAction)btnDay5Selected:(id)sender;


@end

