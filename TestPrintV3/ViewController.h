//
//  ViewController.h
//  TestPrintV3
//
//  Created by barroso on 4/3/18.
//  Copyright © 2018 Orionbelt.com LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRWLANPrintOperation.h"

@protocol BRPrintResultViewControllerDelegate <NSObject>
- (void) showPrintResultForWLAN;
- (void) showPrintResultForBluetooth;
@end

@interface ViewController : UIViewController <BRWLANPrintOperationDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *image;

@property (nonatomic, weak)id<BRPrintResultViewControllerDelegate> delegate;


@end

