//
//  FindTableViewController.m
//  TestPrintV3
//
//  Created by barroso on 4/3/18.
//  Copyright © 2018 Orionbelt.com LLC. All rights reserved.
//

#import "FindTableViewController.h"
#import <BRPtouchPrinterKit/BRPtouchPrinterKit.h>
#import "UserDefaults.h"

@interface FindTableViewController ()

@end

@implementation FindTableViewController
{
    NSMutableArray *_brotherDeviceList;
    BRPtouchNetworkManager    *_networkManager;
    UIActivityIndicatorView    *_indicator;
    UIView *_loadingView;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    _brotherDeviceList = [[NSMutableArray alloc] initWithCapacity:0];
    
    _networkManager = [[BRPtouchNetworkManager alloc] init];
    _networkManager.delegate = self;
    
    _networkManager.isEnableIPv6Search = NO;
    
    NSString *    path = [[NSBundle mainBundle] pathForResource:@"PrinterList" ofType:@"plist"];
    if( path )
    {
        NSDictionary *printerDict = [NSDictionary dictionaryWithContentsOfFile:path];
        NSArray *printerList = [[NSArray alloc] initWithArray:printerDict.allKeys];
        [_networkManager setPrinterNames:printerList];
    }
    
    [_networkManager startSearch: 5.0];
    
    //    Create indicator View
    _loadingView = [[UIView alloc] initWithFrame:[self.parentViewController.view bounds]];
    [_loadingView setBackgroundColor:[UIColor blackColor]];
    [_loadingView setAlpha:0.5];
    [self.parentViewController.view addSubview:_loadingView];
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _indicator.frame = CGRectMake(140.0, 200, 40.0, 40.0);
    [self.parentViewController.view addSubview:_indicator];
    
    //    Start indicator animation
    [_indicator startAnimating];
    
}


////////////////////////////////////////////////////////////////////////////////////
//
//    BRPtouchNetwork delegate method
//
////////////////////////////////////////////////////////////////////////////////////
-(void)didFinishSearch:(id)sender
{
    NSLog(@"didFinishedSearch");
    
    [_indicator stopAnimating];          //  stop indicator animation
    [_indicator removeFromSuperview];    //  remove indicator view (indicator)
    [_loadingView removeFromSuperview];  //  remove indicator view (view)
    
    //  get BRPtouchNetworkInfo Class list
    [_brotherDeviceList removeAllObjects];
    _brotherDeviceList = (NSMutableArray*)[_networkManager getPrinterNetInfo];
    
    NSLog(@"_brotherDeviceList [%@]",_brotherDeviceList);
    
    // reload TableView
    [self.tableView reloadData];
    
    return;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _brotherDeviceList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellForRowAtIndexPath");
    static NSString *eaAccessoryCellIdentifier = @"brotherDeviceCellIdentifier";
    NSUInteger row = [indexPath row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:eaAccessoryCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:eaAccessoryCellIdentifier];
    }
    
    NSString *brotherDeviceName = [(BRPtouchDeviceInfo *)[_brotherDeviceList objectAtIndex:row] strModelName];
    if (!brotherDeviceName || [brotherDeviceName isEqualToString:@""]) {
        brotherDeviceName = @"unknown";
    }
    
    [[cell textLabel] setText:brotherDeviceName];
    [[cell detailTextLabel] setText:[(BRPtouchDeviceInfo *)[_brotherDeviceList objectAtIndex:row] strIPAddress]];
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    
    BRPtouchDeviceInfo *_selectedAccessory = (BRPtouchDeviceInfo *)[_brotherDeviceList objectAtIndex:row];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_selectedAccessory.strModelName forKey:kSelectedDevice];
    [userDefaults setObject:_selectedAccessory.strIPAddress forKey:kIPAddress];
    [userDefaults setObject:@"0"                            forKey:kSerialNumber];
    
    [userDefaults setObject:@"1" forKey:kIsWiFi];
    [userDefaults setObject:@"0" forKey:kIsBluetooth];
    [userDefaults setObject:_selectedAccessory.strModelName forKey:kSelectedDeviceFromWiFi];
    [userDefaults setObject:@"Search device from Bluetooth" forKey:kSelectedDeviceFromBluetooth];
    
    [userDefaults synchronize];
    
    /* Store Model Name and Serial Number */
    NSLog(@"Accessory.name[%@]" ,_selectedAccessory.strModelName);
    NSLog(@"Accessory.IP[%@]"   ,_selectedAccessory.strIPAddress);
    
    [[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
