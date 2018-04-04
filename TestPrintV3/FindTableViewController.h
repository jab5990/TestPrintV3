//
//  FindTableViewController.h
//  TestPrintV3
//
//  Created by barroso on 4/3/18.
//  Copyright © 2018 Orionbelt.com LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BRPtouchPrinterKit/BRPtouchNetworkManager.h>

typedef enum BRSearchMode : NSInteger
{
    BRSearchModeIPv4,
    BRSearchModeIPv6IPv4,
} BRSearchMode;

@interface FindTableViewController : UITableViewController <BRPtouchNetworkDelegate>

@property (assign, nonatomic) BRSearchMode mSearchMode;

@end
