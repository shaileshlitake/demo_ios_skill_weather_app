//
//  ViewController.m
//  app_Weather
//
//  Created by Barclays on 11/05/17.
//  Copyright © 2017 Wipro. All rights reserved.
//

#import "ViewController.h"

#import "G_NetworkManager.h"
#import "CityWeather.h"
#import <CoreLocation/CoreLocation.h>
#import "tempTableViewCell.h"


static NSString * const cellIdentifier = @"tempTableViewCell";

@interface ViewController ()  <CLLocationManagerDelegate>
{
   CityWeather *cityWeather;
    
   DayWeather *weather;
    
   NSArray *tableViewDataArray;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *lblCityName;
@property (nonatomic, weak) IBOutlet UILabel *lblDate;
@property (nonatomic, weak) IBOutlet UILabel *lblMinTemp;
@property (nonatomic, weak) IBOutlet UILabel *lblMaxTemp;
@property (nonatomic, weak) IBOutlet UILabel *lblCurrentTemp;
@property (nonatomic, weak) IBOutlet UILabel *lblweatherDescription;
@property (nonatomic, weak) IBOutlet UILabel *time;
@property (nonatomic, weak) IBOutlet UILabel *lblhumidity;
@property (nonatomic, weak) IBOutlet UILabel *lblpressure;

@end


//Error messages
static NSString * const kError = @"Error";
static NSString * const kError_Msg_InternetNotAvailable = @"Internet Connection Error, Please connect to internet.";
static NSString * const kError_Msg_Service_Not_Available = @"Server Connection Error";
static NSString * const kError_Msg_JSONParsing = @"Error while parsing web response.";




@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.estimatedRowHeight = 44;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.hostRechable = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    [self.hostRechable startNotifier];
    
    [self updateInternetConnectionStatus:self.hostRechable];
    
    self.internetRechable = [Reachability reachabilityForInternetConnection];
    
    [self.internetRechable startNotifier];
    
    [self updateInternetConnectionStatus:self.internetRechable];
    
    [self initialiseCellNib];
    
    [self startActivityIndicator];
    
    [self fetchWeatherData];


   
    
}


- (void)refreshData{
    
    self.lblCityName.text = cityWeather.cityName;
    
    [self loadTableData:cityWeather.day1Report recordIndex:0];
    
    /* Setting up button time for 5 days*/
    
    [self.btnDay1 setTitle:[self getDateForUI:((DayWeather *)[cityWeather.day1Report objectAtIndex:0]).strDate] forState:UIControlStateNormal];
    
    [self.btnDay2 setTitle:[self getDateForUI:((DayWeather *)[cityWeather.day2Report objectAtIndex:0]).strDate] forState:UIControlStateNormal];
    
    [self.btnDay3 setTitle:[self getDateForUI:((DayWeather *)[cityWeather.day3Report objectAtIndex:0]).strDate] forState:UIControlStateNormal];
    
    [self.btnDay4 setTitle:[self getDateForUI:((DayWeather *)[cityWeather.day4Report objectAtIndex:0]).strDate] forState:UIControlStateNormal];
    
    [self.btnDay5 setTitle:[self getDateForUI:((DayWeather *)[cityWeather.day5Report objectAtIndex:0]).strDate] forState:UIControlStateNormal];
    
    
    
  
}

-(void) loadTableData:(NSArray *) p_TableData recordIndex:(int)p_Index
{
    /* loading data in table view */
    
    tableViewDataArray = p_TableData ;
    
    DayWeather *l_dayWeather = (DayWeather *)[p_TableData objectAtIndex:p_Index];
    
    self.lblDate.text = l_dayWeather.strDate;
    
    self.lblCurrentTemp.text = [NSString stringWithFormat:@"%@" ,l_dayWeather.temp ] ;
    
    self.lblweatherDescription.text = l_dayWeather.descriptionString;
    
    self.lblMinTemp.text =  [NSString stringWithFormat:@"Min: %@" ,l_dayWeather.temp_min ] ;
    
     self.lblMaxTemp.text =  [NSString stringWithFormat:@"Max: %@" ,l_dayWeather.temp_max ] ;
    
     self.lblhumidity.text =  [NSString stringWithFormat:@"%@" ,l_dayWeather.humidity ] ;
    
    self.lblpressure.text =  [NSString stringWithFormat:@"Pressure: %@" ,l_dayWeather.pressure ] ;
    
    
    [self.tableView reloadData];

}


-(IBAction)btnDay1Selected:(id)sender
{
    [self loadTableData:cityWeather.day1Report recordIndex:0];
}

-(IBAction)btnDay2Selected:(id)sender
{
[self loadTableData:cityWeather.day2Report recordIndex:0];
}

-(IBAction)btnDay3Selected:(id)sender
{
  [self loadTableData:cityWeather.day3Report recordIndex:0];
}

-(IBAction)btnDay4Selected:(id)sender
{
 [self loadTableData:cityWeather.day4Report recordIndex:0];
}

-(IBAction)btnDay5Selected:(id)sender
{
    [self loadTableData:cityWeather.day5Report recordIndex:0];
}


-(NSString *)getDateForUI:(NSString *)dateFromData
{
    NSMutableArray *dateArray = [[NSMutableArray alloc] initWithArray:[dateFromData componentsSeparatedByString:@"-"]];
    
    [dateArray removeObjectAtIndex:0];
    
    NSString *returnDate = [dateArray componentsJoinedByString:@"-"];
    
    return returnDate;
}




/***********************************************
 *  This function used to initaite request to get data from weather service.
 ***********************************************/

- (void)fetchWeatherData{
    
    
    // Fetch Data for 5 day Weather Trend
    [[G_NetworkManager sharedNetworkHandlerManager] getWeatherDataWithSuccess:^(id expectedObject) {
        //updateing UI
        
        cityWeather = (CityWeather*)expectedObject;
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self refreshData];
            
            [self stopActivityIndicator];
            
         
        });
        
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
             [self stopActivityIndicator];
            
            
        });
        
    }];
}



/***********************************************
 *  This function will be Called by Reachability whenever network status get change.
 ***********************************************/

- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    
    [self updateInternetConnectionStatus:curReach];
}


- (void)updateInternetConnectionStatus:(Reachability *)reachability
{
    if (reachability == self.hostRechable)
    {
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
        
        switch (netStatus)
        {
            case NotReachable: {
                
                [self showAlertViewControllerWithTitle:kError andMessage:kError_Msg_Service_Not_Available];
                
                break;
            }
                
            default:{
                
                NSLog(@"host can be reach.");
                
                break;
            }
        }
    }
    if (reachability == self.internetRechable)
    {
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
        
        switch (netStatus)
        {
            case NotReachable: {
                
                [self showAlertViewControllerWithTitle:kError andMessage:kError_Msg_InternetNotAvailable];
                
                break;
            }
                
            default:{
                
                NSLog(@"Internet is reach.");
                
                break;
            }
        }
    }
}

- (void)showAlertViewControllerWithTitle:(NSString*)title andMessage:(NSString*)message{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)startActivityIndicator{
    
    [self.activityIndicatorView startAnimating];
}

- (void)stopActivityIndicator{
    
    [self.activityIndicatorView stopAnimating];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


/* ********************************
*   Table view related function *
 **********************************/


-(void)initialiseCellNib
{
    [self.tableView registerNib:[UINib nibWithNibName:@"tempTableViewCell" bundle:nil] forCellReuseIdentifier:@"tempTableViewCell"];
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    
    cell.contentView.backgroundColor = [UIColor clearColor];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [tableViewDataArray count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    tempTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    DayWeather *weatherObject = [tableViewDataArray objectAtIndex:indexPath.row];
    
    cell.weatherDetailsLabel.text = [weatherObject.descriptionString capitalizedString];
    
    cell.timeLabel.text = [NSString stringWithFormat:@"%@        %@",weatherObject.time , weatherObject.temp] ;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    [self loadTableData:tableViewDataArray recordIndex:(int)indexPath.row];
    
    
    
}





@end
