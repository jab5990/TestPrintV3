//
//  BRWLANPrintOperation.h
//  TestPrintV3
//
//  Created by barroso on 4/4/18.
//  Copyright © 2018 Orionbelt.com LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BRPtouchPrinterKitW/BRPtouchPrinterKit.h>

@protocol BRWLANPrintOperationDelegate <NSObject>
- (void) showPrintResultForWLAN;
@end

@interface BRWLANPrintOperation : NSOperation
{
}
@property (nonatomic, weak)id<BRWLANPrintOperationDelegate> delegate;
@property(nonatomic, assign) BOOL communicationResultForWLAN;

- (id)initWithOperation:(BRPtouchPrinter *)targetPtp
              printInfo:(BRPtouchPrintInfo *)targetPrintInfo
                 imgRef:(CGImageRef)targetImgRef
          numberOfPaper:(int)targetNumberOfPaper
              ipAddress:(NSString *)targetIPAddress
        customPaperFile:(NSString *)targetCustomPaperFilePath;
@end


