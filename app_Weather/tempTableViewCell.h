//
//  tempTableViewCell.h
//  app_Weather
//
//  Created by Barclays on 12/05/17.
//  Copyright © 2017 Wipro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tempTableViewCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UILabel *timeLabel;
@property(nonatomic,weak)IBOutlet UILabel *weatherDetailsLabel;

@end
