//
//  UserDefaults.h
//  SDK_Sample_Ver2
//
//  Created by Kusumoto Naoki on 2015/04/20.
//  Copyright (c) 2015年 Kusumoto Naoki. All rights reserved.
//

#ifndef ___USER_DEFAULTS___
#define ___USER_DEFAULTS___

#pragma mark - Default Setting

#define kSelectedDevice		@"SelectedDevice"
#define kIPAddress          @"IPAddress"
#define kSerialNumber		@"SerialNumber"

#define kSelectedDeviceFromWiFi         @"SelectedDeviceFromWiFi"
#define kSelectedDeviceFromBluetooth    @"SelectedDeviceFromBluetooth"

#define kIsWiFi                         @"isWiFi"
#define kIsBluetooth                    @"isBluetooth"

#define kPrintResultForWLAN     @"printResultForWLAN"
#define kPrintResultForBT       @"printResultForBT"

#define kPrintStatusBatteryPowerForWLAN     @"printStatusBatteryPowerForWLAN"
#define kPrintStatusBatteryPowerForBT       @"printStatusBatteryPowerForBT"

#define kSelectedSendDataPath       @"selectedSendDataPath"
#define kSelectedSendDataName       @"selectedSendDataName"

#define kSelectedPDFFilePath       @"selectedPDFFilePath"

#pragma mark - Print Settings

// Item 0
#define kExportPrintFileNameKey @"ExportPrintFileNameKey"

// Item 1
#define kPrintNumberOfPaperKey		@"PrintNumberOfPaperKey"

// Item 2
#define kPrintPaperSizeKey		@"PrintPaperSizeKey"
enum PrintPaperSize
{
    A4 = 1,
    Letter,
    Legal
};

// Item 3
#define kPrintOrientationKey		@"PrintOrientationKey"
enum PrintOrientationKey
{
    Landscape   = 0x00,
    Portrate    = 0x01
};

// Item 4
#define kScalingModeKey		@"ScalingModeKey"
enum PrintFitKey
{
    Original    = 0x00,
    Fit         = 0x01,
    Custom      = 0x02
};

// Item 5
#define kScalingFactorKey		@"ScalingFactorKey"

// Item 6
#define kPrintHalftoneKey		@"PrintHalftoneKey"
enum PrintHalftoneKey
{
    Binary          = 0x00,
    Dither          = 0x01,
    ErrorDiffusion  = 0x02
};

// Item 7
#define kPrintHorizintalAlignKey		@"PrintHorizintalAlignKey"
enum PrintHorizintalAlignKey
{
    Left    = 0x00,
    Center  = 0x01,
    Right   = 0x02
};

// Item 8
#define kPrintVerticalAlignKey		@"PrintVerticalAlignKey"
enum PrintVerticalAlignKey
{
    Top     = 0x00,
    Middle  = 0x01,
    Bottom  = 0x02
};

// Item 9
#define kPrintPaperAlignKey     @"PrintPaperAlignKey"
enum PrintPaperAlignKey
{
    PaperLeft   = 0x00,
    PaperCenter = 0x01,
    PaperRight  = 0x02
};

// Item 10
#define kPrintCodeKey		@"PrintCodeKey"
enum PrintCodeKey
{
    CodeOn  = 0x01,
    CodeOff = 0x00
};

// Item 11
#define kPrintCarbonKey		@"PrintCarbonKey"
enum PrintCarbonKey
{
    CarbonOn  = 0x02,
    CarbonOff = 0x00
};

// Item 12
#define kPrintDashKey		@"PrintDashKey"
enum PrintDashKey
{
    DashOn  = 0x04,
    DashOff = 0x00
};

// Item 13
#define kPrintFeedModeKey		@"PrintFeedModeKey"
enum PrintFeedModeKey
{
    NoFeed              = 0x08,
    EndOfPage           = 0x10,
    EndOfPageRetract    = 0x20,
    FixPage             = 0x40
};

// Item 14
#define kPrintCurlModeKey		@"PrintCurlModeKey"
enum PrintCurlModeKey
{
    CurlModeOff = 0x01,
    CurlModeOn  = 0x02,
    AntiCurl    = 0x03,
};

// Item 15
#define kPrintSpeedKey		@"PrintSpeedKey"
enum PrintSpeed
{
    Faster      = 0x00,
    Fast        = 0x01,
    Slowly      = 0x02,
    MoreSlowly  = 0x03
};

// Item 16
#define kPrintBidirectionKey		@"PrintBidirectionKey"
enum PrintBidirectionKey
{
    BidirectionOn  = 0x01,
    BidirectionOff = 0x00
};

// Item 17
#define kPrintFeedMarginKey		@"PrintFeedMarginKey"

// Item 18
#define kPrintCustomLengthKey   @"PrintCustomLengthKey"

// Item 19
#define kPrintCustomWidthKey	@"PrintCustomWidthKey"

// Item 20
#define kPrintAutoCutKey        @"PrintAutoCutKey"
enum PrintAutoCutKey
{
    AutoCutOn  = 0x01,
    AutoCutOff = 0x00
};

// Item 21
#define kPrintCutAtEndKey     @"PrintCutAtEndKey"
enum PrintCutAtEndKey
{
    CutAtEndOn  = 0x02,
    CutAtEndOff = 0x00
};

// Item 22
#define kPrintHalfCutKey        @"PrintHalfCutKey"
enum PrintHalfCutKey
{
    HalfCutOn  = 0x04,
    HalfCutOff = 0x00
};

// Item 23
#define kPrintSpecialTapeKey	@"PrintSpecialTapeKey"
enum PrintSpecialTapeKey
{
    SpecialTapeOn  = 0x10,
    SpecialTapeOff = 0x00
};

// Item 24
#define kRotateKey		@"RotateKey"
enum RotateKey
{
    RotateOn  = 0x01,
    RotateOff = 0x00
};

// Item 25
#define kPeelKey		@"PeelKey"
enum PeelKey
{
    PeelOn  = 0x01,
    PeelOff = 0x00
};

// Item 26
#define kPrintCustomPaperKey	@"PrintCustomPaperKey"

// Item 27
#define kPrintCutMarkKey		@"PrintCutMarkKey"
enum PrintCutMarkKey
{
    CutMarkOn  = 0x01,
    CutMarkOff = 0x00
};

// Item 28
#define kPrintLabelMargineKey		@"PrintLabelMargineKey"

// Item 29
#define kPrintDensityMax5Key		@"PrintDensityMax5Key"
enum PrintDensityMax5Key
{
    DensityMax5Levelminus5  = 0xFB,
    DensityMax5Levelminus4  = 0xFC,
    DensityMax5Levelminus3  = 0xFD,
    DensityMax5Levelminus2  = 0xFE,
    DensityMax5Levelminus1  = 0xFF,
    DensityMax5Level0       = 0x00,
    DensityMax5Level1       = 0x01,
    DensityMax5Level2       = 0x02,
    DensityMax5Level3       = 0x03,
    DensityMax5Level4       = 0x04,
    DensityMax5Level5       = 0x05
};

// Item 30
#define kPrintDensityMax10Key		@"PrintDensityMax10Key"
enum PrintDensityMax10Key
{
    DensityMax10Level0   = 0x00,
    DensityMax10Level1   = 0x01,
    DensityMax10Level2   = 0x02,
    DensityMax10Level3   = 0x03,
    DensityMax10Level4   = 0x04,
    DensityMax10Level5   = 0x05,
    DensityMax10Level6   = 0x06,
    DensityMax10Level7   = 0x07,
    DensityMax10Level8   = 0x08,
    DensityMax10Level9   = 0x09,
    DensityMax10Level10  = 0x0A
};

// Item31
#define kPrintTopMarginKey		@"PrintTopMarginKey"

// Item32
#define kPrintLeftMarginKey		@"PrintLeftMarginKey"

// Item33
#define kPJPaperKindKey		@"PJPaperKindKey"
enum PJPaperKindKey
{
    PJRoll = 0x01,
    PJCutPaper = 0x02
};

// Item34
// 20170727
// 16進数の形式で値をセットする必要がないため、10進数の形で設定している
//（※おそらく、今までは16進入力の必要のないものまで、16進数をセットしていた可能性がある）
#define kPirintQuality		@"PrintQualityKey"
enum PrintQualityKey
{
    LowResolution = 1,
    Normal = 2,
    DoubleSpeed = 3,
    HighResolution = 4
};

// Item 35
#define kPrintMode9		@"PrintMode9"
enum PrintMode9Key
{
    Mode9ON  = 1,
    MOde9OFF = 0
};

// Item 36
#define kPrintRawMode		@"PrintRawMode"
enum PrintRawModeKey
{
    RawModeON  = 1,
    RawModeOFF = 0
};

#endif
