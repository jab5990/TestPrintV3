//
//  BRWLANPrintOperation.m
//  TestPrintV3
//
//  Created by barroso on 4/4/18.
//  Copyright © 2018 Orionbelt.com LLC. All rights reserved.
//

#import "UserDefaults.h"
#import "BRWLANPrintOperation.h"

@interface BRWLANPrintOperation ()
{
}
@property(nonatomic, assign) BOOL isExecutingForWLAN;
@property(nonatomic, assign) BOOL isFinishedForWLAN;


@property(nonatomic, weak) BRPtouchPrinter    *ptp;
@property(nonatomic, strong) BRPtouchPrintInfo  *printInfo;
@property(nonatomic, assign) CGImageRef         imgRef;
@property(nonatomic, assign) int                numberOfPaper;
@property(nonatomic, strong) NSString           *ipAddress;
@property(nonatomic, strong) NSString           *customPaperFilePath;
@end

@implementation BRWLANPrintOperation

- (id)initWithOperation:(BRPtouchPrinter *)targetPtp
              printInfo:(BRPtouchPrintInfo *)targetPrintInfo
                 imgRef:(CGImageRef)targetImgRef
          numberOfPaper:(int)targetNumberOfPaper
              ipAddress:(NSString *)targetIPAddress
        customPaperFile:targetCustomPaperFilePath


{
    self = [super init];
    if (self) {
        self.ptp            = targetPtp;
        self.printInfo      = targetPrintInfo;
        self.imgRef         = targetImgRef;
        self.numberOfPaper  = targetNumberOfPaper;
        self.ipAddress      = targetIPAddress;
        self.customPaperFilePath = targetCustomPaperFilePath;
        
    }
    
    return self;
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString*)key
{
   if ([key isEqualToString:@"communicationResultForWLAN"] ||
        [key isEqualToString:@"isExecutingForWLAN"]         ||
        [key isEqualToString:@"isFinishedForWLAN"]) {
        return YES;
    }
    return [super automaticallyNotifiesObserversForKey:key];
}

- (void)start
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.isExecutingForWLAN = YES;
    
    [self.ptp setIPAddress:self.ipAddress];
    
    if ([self.ptp isPrinterReady])
    {
        [self.ptp startCommunication];
        
        [self.ptp setPrintInfo:self.printInfo];
        [self.ptp setCustomPaperFile:self.customPaperFilePath];
        
        int printResult = [self.ptp printImage:self.imgRef copy:self.numberOfPaper];
        
        [userDefaults setObject:[NSString stringWithFormat:@"%d", printResult] forKey:kPrintResultForWLAN];
        [userDefaults synchronize];
        
        PTSTATUSINFO resultstatus;
        BOOL result = [self.ptp getPTStatus:&resultstatus];
        if (result) {
            [userDefaults setObject:[NSString stringWithFormat:@"%d", resultstatus.byFiller] forKey:kPrintStatusBatteryPowerForWLAN];
            [userDefaults synchronize];
        }
        else if (!result) {
            // Error
        }
        if ([self.delegate respondsToSelector:@selector(showPrintResultForWLAN)]) {
            [self.delegate showPrintResultForWLAN];
        }

        [self.ptp endCommunication];
        
    }
    
}

@end
