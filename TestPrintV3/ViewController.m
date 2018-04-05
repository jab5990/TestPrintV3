//
//  ViewController.m
//  TestPrintV3
//
//  Created by barroso on 4/3/18.
//  Copyright © 2018 Orionbelt.com LLC. All rights reserved.
//

#import "ViewController.h"
#import <BRPtouchPrinterKitW/BRPtouchPrinterKit.h>
#import "BRWLANPrintOperation.h"
#import "UserDefaults.h"


@interface ViewController ()
{
    BRPtouchPrinter    *_ptp;
}

@property(nonatomic, strong) NSOperationQueue           *queueForWLAN;
@property(nonatomic, strong) BRWLANPrintOperation       *operationForWLAN;

@property(nonatomic, strong) NSString *bytesWrittenMessage;
@property(nonatomic, strong) NSNumber *bytesWritten;
@property(nonatomic, strong) NSNumber *bytesToWrite;

@property(nonatomic, assign) CONNECTION_TYPE type;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWithUserDefault];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.printerIP.text = [userDefaults stringForKey:kSelectedDevice];
    self.printerName.text = [userDefaults stringForKey:kIPAddress];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

}


- (void)createImage
{
    UIImage *image;
    image = [self imageFromTextWithPic];
    self.image.image = image;
    
}

- (UIImage *)imageFromTextWithPic
{
    UIImage *pic = [UIImage imageNamed:@"empty_back.png"];
    
    UIFont *font2 = [UIFont systemFontOfSize:60.0];
    UIFont *font = [UIFont systemFontOfSize:50.0];
    UIFont *font3 = [UIFont systemFontOfSize:20.0];
    CGSize size = CGSizeMake(550, 300);
    
    UIGraphicsBeginImageContext(size);


    [pic drawInRect:CGRectMake(0.0, 15.0, 200.0, 250.0)];

    // Name
    NSString *name = @"Jose Barroso";
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    NSDictionary *attr3 = [NSDictionary dictionaryWithObject:style forKey:NSParagraphStyleAttributeName];
    NSDictionary *normalDict3 = [[NSDictionary alloc]initWithObjectsAndKeys:style,NSParagraphStyleAttributeName, font, NSFontAttributeName, nil];
    [name drawInRect:CGRectMake(210.0, 100.0, 300.0, 150.0) withAttributes:normalDict3];
    
    // Date
    NSString *dateIn = @"April 5, 2018    8:34 AM";
    NSDictionary *attr2 = [NSDictionary dictionaryWithObject:style forKey:NSParagraphStyleAttributeName];
    NSDictionary *normalDict2 = [[NSDictionary alloc]initWithObjectsAndKeys:style,NSParagraphStyleAttributeName, font3, NSFontAttributeName, nil];
    [dateIn drawInRect:CGRectMake(210.0, 200.0, 300.0, 80.0) withAttributes:normalDict2];
     

    // Header
    NSString *header = @"Visitor";
    NSDictionary *attr = [NSDictionary dictionaryWithObject:style forKey:NSParagraphStyleAttributeName];
    NSDictionary *normalDict = [[NSDictionary alloc]initWithObjectsAndKeys:style,NSParagraphStyleAttributeName, font2, NSFontAttributeName, nil];
    [header drawInRect:CGRectMake(210.0, 15.0, 300.0, 100.0) withAttributes:normalDict];


    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (IBAction)print:(id)sender
{
    [self createImage];
    
    [self prepareForPtp];
    if (_ptp)
    {
        if ([_ptp isPrinterReady]){
            [self prepareForPrintResult];
        }
        else {
            // Connection Error
        }
    }
    
}


- (void) prepareForPrintResult
{
    self.bytesWritten = [NSNumber numberWithInt:0];
    self.bytesToWrite = [NSNumber numberWithInt:0];
    self.type = CONNECTION_TYPE_ERROR;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *selectedDevice = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [paths lastObject];
    
    self.type = CONNECTION_TYPE_WLAN;
    selectedDevice = [NSString stringWithFormat:@"%@", [userDefaults stringForKey:kSelectedDeviceFromWiFi]];
    
    
    NSString *ipAddress     = [userDefaults stringForKey:kIPAddress];
    NSString *serialNumber  = [userDefaults stringForKey:kSerialNumber];
    
    // PrintInfo
    BRPtouchPrintInfo *printInfo = [[BRPtouchPrintInfo alloc] init];
    
    if ([[userDefaults stringForKey:kExportPrintFileNameKey] isEqualToString:@""]) {
        printInfo.strSaveFilePath    = @"";
    }
    else {
        NSString *fileName = [[userDefaults stringForKey:kExportPrintFileNameKey] stringByAppendingPathExtension:@"prn"];
        NSString *filePath = [directory stringByAppendingPathComponent:fileName];
        printInfo.strSaveFilePath = filePath; // Item 0
    }
    
    NSString *numPaper = [userDefaults stringForKey:kPrintNumberOfPaperKey]; // Item 1
    
    printInfo.strPaperName        = [userDefaults stringForKey:kPrintPaperSizeKey]; // Item 2
    printInfo.nOrientation        = (int)[userDefaults integerForKey:kPrintOrientationKey]; // Item 3
    printInfo.nPrintMode        = (int)[userDefaults integerForKey:kScalingModeKey]; // Item 4
    printInfo.scaleValue        = [userDefaults doubleForKey:kScalingFactorKey]; // Item 5
    
    printInfo.nHalftone            = (int)[userDefaults integerForKey:kPrintHalftoneKey]; // Item 6
    printInfo.nHorizontalAlign    = (int)[userDefaults integerForKey:kPrintHorizintalAlignKey]; // Item 7
    printInfo.nVerticalAlign    = (int)[userDefaults integerForKey:kPrintVerticalAlignKey]; // Item 8
    printInfo.nPaperAlign        = (int)[userDefaults integerForKey:kPrintPaperAlignKey]; // Item 9
    
    printInfo.nExtFlag |= (int)[userDefaults integerForKey:kPrintCodeKey]; // Item 10
    printInfo.nExtFlag |= (int)[userDefaults integerForKey:kPrintCarbonKey]; // Item 11
    printInfo.nExtFlag |= (int)[userDefaults integerForKey:kPrintDashKey]; // Item 12
    printInfo.nExtFlag |= (int)[userDefaults integerForKey:kPrintFeedModeKey]; // Item 13
    
    printInfo.nRollPrinterCase    = (int)[userDefaults integerForKey:kPrintCurlModeKey]; // Item 14
    printInfo.nSpeed            = (int)[userDefaults integerForKey:kPrintSpeedKey]; // Item 15
    printInfo.bBidirection      = (int)[userDefaults integerForKey:kPrintBidirectionKey]; // Item 16
    
    printInfo.nCustomFeed   = (int)[userDefaults integerForKey:kPrintFeedMarginKey]; // Item 17
    printInfo.nCustomLength = (int)[userDefaults integerForKey:kPrintCustomLengthKey]; // Item 18
    printInfo.nCustomWidth  = (int)[userDefaults integerForKey:kPrintCustomWidthKey]; // Item 19
    
    printInfo.nAutoCutFlag  |= (int)[userDefaults integerForKey:kPrintAutoCutKey]; // Item 20
    printInfo.bEndcut = (int)[userDefaults integerForKey:kPrintCutAtEndKey]; // Item 21
    printInfo.bHalfCut       = (int)[userDefaults integerForKey:kPrintHalfCutKey]; // Item 22
    printInfo.bSpecialTape      = (int)[userDefaults integerForKey:kPrintSpecialTapeKey]; // Item 23
    printInfo.bRotate180     = (int)[userDefaults integerForKey:kRotateKey]; // Item 24
    printInfo.bPeel          = (int)[userDefaults integerForKey:kPeelKey]; // Item 25
    
    NSString *customPaper = [userDefaults stringForKey:kPrintCustomPaperKey]; // Item 26
    NSString *customPaperFilePath = nil;
    if(![customPaper isEqualToString:@"NoCustomPaper"]) {
        customPaperFilePath = [NSString stringWithFormat:@"%@/%@",directory, [userDefaults stringForKey:kPrintCustomPaperKey]];
    }
    
    printInfo.bCutMark      = (int)[userDefaults integerForKey:kPrintCutMarkKey]; // Item 27
    printInfo.nLabelMargine = (int)[userDefaults integerForKey:kPrintLabelMargineKey]; // Item 28
    
    if ([selectedDevice rangeOfString:@"RJ-"].location != NSNotFound ||
        [selectedDevice rangeOfString:@"TD-"].location != NSNotFound) {
        printInfo.nDensity = (int)[userDefaults integerForKey:kPrintDensityMax5Key]; // Item 29
    }
    else if([selectedDevice rangeOfString:@"PJ-"].location != NSNotFound){
        printInfo.nDensity = (int)[userDefaults integerForKey:kPrintDensityMax10Key]; // Item 30
    }
    else {
        // Error
    }
    
    printInfo.nTopMargin   = (int)[userDefaults integerForKey:kPrintTopMarginKey]; // Item 31
    printInfo.nLeftMargin   = (int)[userDefaults integerForKey:kPrintLeftMarginKey]; // Item 32
    
    printInfo.nPJPaperKind = (int)[userDefaults integerForKey:kPJPaperKindKey];// Item 33
    
    printInfo.nPrintQuality = (int)[userDefaults integerForKey:kPirintQuality];// Item 34
    
    printInfo.bMode9 = (int)[userDefaults integerForKey:kPrintMode9];// Item 35
    printInfo.bRawMode = (int)[userDefaults integerForKey:kPrintRawMode];// Item 36
    
    
    if (self.type != CONNECTION_TYPE_ERROR)
    {
        _ptp = [[BRPtouchPrinter alloc] initWithPrinterName:selectedDevice interface:self.type];
        CGImageRef imgRef = [self.image.image CGImage];
        

        self.queueForWLAN = [[NSOperationQueue alloc] init];
        self.operationForWLAN = [[BRWLANPrintOperation alloc] initWithOperation:_ptp
                                                                      printInfo:printInfo
                                                                         imgRef:imgRef
                                                                  numberOfPaper:[numPaper intValue]
                                                                      ipAddress:ipAddress
                                                                customPaperFile:customPaperFilePath];
        [self.operationForWLAN addObserver:self
                                forKeyPath:@"isFinishedForWLAN"
                                   options:NSKeyValueObservingOptionNew
                                   context:nil];
        
        [self.operationForWLAN addObserver:self
                                forKeyPath:@"communicationResultForWLAN"
                                   options:NSKeyValueObservingOptionNew
                                   context:nil];
        
        self.operationForWLAN.delegate = self;
        
        [self.queueForWLAN addOperation:self.operationForWLAN];
    }

}


- (void) showConnectionErrorAlert
{
    float osVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if(osVersion >= 8.0f) {
        UIAlertController * alertController =
        [UIAlertController alertControllerWithTitle:@"Error"
                                            message:@"Communication Error"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * okAction =
        [UIAlertAction actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                               handler:nil];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if (osVersion < 8.0f && osVersion >= 6.0f) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Communication Error"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else {
        // Non Support
    }
}



- (void) prepareForPtp
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *selectedDevice = nil;
    
    CONNECTION_TYPE type = CONNECTION_TYPE_WLAN;
    type = CONNECTION_TYPE_WLAN;
    
    selectedDevice = [NSString stringWithFormat:@"%@", [userDefaults stringForKey:kSelectedDeviceFromWiFi]];

    
    if (selectedDevice)
    {
        _ptp = [[BRPtouchPrinter alloc] initWithPrinterName:selectedDevice interface:type];
                [_ptp setIPAddress:[userDefaults objectForKey:kIPAddress]];
        
        [_ptp setIPAddress:[userDefaults objectForKey:kIPAddress]];
    }
}


- (void) initWithUserDefault
{
    // "UserDefault" Initialize
    NSUserDefaults *userDefaults    = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *defaults   = [NSMutableDictionary dictionary];
    
    [userDefaults removeObjectForKey:kPrintCustomPaperKey];
    [userDefaults removeObjectForKey:kSelectedPDFFilePath];
    [userDefaults synchronize];
    
    [defaults setObject:@""                                                 forKey:kExportPrintFileNameKey];
    [defaults setObject:@"1"                                                forKey:kPrintNumberOfPaperKey];
    [defaults setObject:[self defaultPaperSize]                             forKey:kPrintPaperSizeKey];
    // [defaults setObject:[NSString stringWithFormat:@"%d", Landscape]        forKey:kPrintOrientationKey];
    // [defaults setObject:[NSString stringWithFormat:@"%d", Original]         forKey:kScalingModeKey];
    // [defaults setObject:@"0.5"                                              forKey:kScalingFactorKey];
 
    [defaults setObject:[NSString stringWithFormat:@"%d", Portrate]        forKey:kPrintOrientationKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", Original]         forKey:kScalingModeKey];
    [defaults setObject:@"1.0"                                              forKey:kScalingFactorKey];

    
    [defaults setObject:[NSString stringWithFormat:@"%d", Binary]           forKey:kPrintHalftoneKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", Left]             forKey:kPrintHorizintalAlignKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", Top]              forKey:kPrintVerticalAlignKey];
    //[defaults setObject:[NSString stringWithFormat:@"%d", PaperLeft]        forKey:kPrintPaperAlignKey];
    
    // nExtFlag
    [defaults setObject:[NSString stringWithFormat:@"%d", CodeOff]          forKey:kPrintCodeKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", CarbonOff]        forKey:kPrintCarbonKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", DashOff]          forKey:kPrintDashKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", NoFeed]           forKey:kPrintFeedModeKey];
    
    [defaults setObject:[NSString stringWithFormat:@"%d", CurlModeOff]      forKey:kPrintCurlModeKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", Fast]             forKey:kPrintSpeedKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", BidirectionOn]    forKey:kPrintBidirectionKey];
    [defaults setObject:@"0"                                                forKey:kPrintFeedMarginKey];
    [defaults setObject:@"200"                                              forKey:kPrintCustomLengthKey];
    [defaults setObject:@"80"                                               forKey:kPrintCustomWidthKey];
    
    [defaults setObject:[NSString stringWithFormat:@"%d", AutoCutOff]       forKey:kPrintAutoCutKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", CutAtEndOff]      forKey:kPrintCutAtEndKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", HalfCutOff]       forKey:kPrintHalfCutKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", SpecialTapeOff]   forKey:kPrintSpecialTapeKey];
    
    [defaults setObject:@""                                    forKey:kPrintCustomPaperKey];
    
    [defaults setObject:[NSString stringWithFormat:@"%d", RotateOff]        forKey:kRotateKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", PeelOff]          forKey:kPeelKey];
    
    // [defaults setObject:[NSString stringWithFormat:@"%d", CutMarkOff]       forKey:kPrintCutMarkKey];
    [defaults setObject:[NSString stringWithFormat:@"%d", CutMarkOn]       forKey:kPrintCutMarkKey];
    [defaults setObject:@"0"                                                forKey:kPrintLabelMargineKey];
    
    [defaults setObject:[NSString stringWithFormat:@"%d", DensityMax5Level1]    forKey:kPrintDensityMax5Key];
    [defaults setObject:[NSString stringWithFormat:@"%d", DensityMax10Level6]   forKey:kPrintDensityMax10Key];
    
    [defaults setObject:@"0"     forKey:kPrintTopMarginKey];
    [defaults setObject:@"0"     forKey:kPrintLeftMarginKey];
    
    [defaults setObject:[NSString stringWithFormat:@"%d", PJCutPaper]   forKey:kPJPaperKindKey];
    
    [defaults setObject:[NSString stringWithFormat:@"%d", Normal]   forKey:kPirintQuality];
    
    //[defaults setObject:@"No Selected"                                      forKey:kSelectedDevice];
    //[defaults setObject:@""                                                 forKey:kIPAddress];
    //[defaults setObject:@"0"                                                forKey:kSerialNumber];
    // [defaults setObject:@"Search device from Wi-Fi"                         forKey:kSelectedDeviceFromWiFi];
    // [defaults setObject:@"Search device from Bluetooth"                     forKey:kSelectedDeviceFromBluetooth];
    
    [defaults setObject:@"1"                                                forKey:kIsWiFi];
    [defaults setObject:@"0"                                                forKey:kIsBluetooth];
    
    [defaults setObject:@"0"                                                forKey:kSelectedPDFFilePath];
    [defaults setObject:@"1"                                                forKey:kPrintMode9];
    [defaults setObject:@"0"                                                forKey:kPrintRawMode];
    
    [userDefaults registerDefaults:defaults];
}


- (NSString *)defaultPaperSize
{
    NSString *result = nil;
    
    NSString *pathInPrintSettings   = [[NSBundle mainBundle] pathForResource:@"PrinterList" ofType:@"plist"];
    if (pathInPrintSettings) {
        NSDictionary *priterListArray = [NSDictionary dictionaryWithContentsOfFile:pathInPrintSettings];
        if (priterListArray) {
            result = [[[priterListArray objectForKey:@"Brother PJ-673"] objectForKey:@"PaperSize"] objectAtIndex:0];
        }
    }
    
    result = @"62mm";
    // result = @"60mmx86mm";
    
    return result;
}


@end
