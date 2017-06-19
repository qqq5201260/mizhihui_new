//
//  SRBLEUpdateInfo.m
//  Mizward
//
//  Created by zhangjunbo on 15/9/22.
//  Copyright © 2015年 Mizward. All rights reserved.
//

#import "SRBLEUpdateInfo.h"

@implementation SRBLEUpdateInfo

@end

//配置升级
@implementation SRBLEUpdateFirmwareConfig

- (NSString *)stringValue
{
    return [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",
            self.productName,
            self.hardwareVersion,
            self.zoneFormat,
            self.softwareName,
            self.compileType,
            self.softwareVersion];
}

@end


//固件请求
@implementation SRBLEUpdateFirmwareReq

- (instancetype)initWithParameters:(NSArray *)parameters
{
    if (!parameters || parameters.count < 4) {
        return nil;
    }
    
    self = [super init];
    
    _sectionNumber = strtoul([parameters[0] UTF8String], 0, 16);
    _sectionVersion = strtoul([parameters[1] UTF8String], 0, 16);
    _zoneLength = strtoul([parameters[2] UTF8String], 0, 16);
    _firmwareVersion = strtoul([parameters[3] UTF8String], 0, 16);
    
    return self;
}

@end

//固件响应
@implementation SRBLEUpdateFirmwareRsp

- (instancetype)initWithUpdateInfo:(SRBLEUpdateInfo *)info
{
    if (!info) return nil;
    
    self = [super init];
    
    _byteSize = info.byteSize;
    _sectionCount = info.sectionCount;
    _crcCount = info.totalCheck;
    
    return self;
}

- (NSString *)stringValue
{
    return [NSString stringWithFormat:@"%x,%x,%@",
            (UInt8)self.byteSize&0xff,
            (UInt8)self.sectionCount&0xff,
            self.crcCount];
}

@end

//分片请求
@implementation SRBLEUpdateZoneReq

- (instancetype)initWithParameters:(NSArray *)parameters
{
    if (!parameters || parameters.count <= 0) {
        return nil;
    }
    
    self = [super init];
    
    NSMutableArray *zoneNumbers = [NSMutableArray arrayWithCapacity:parameters.count];
    [parameters enumerateObjectsUsingBlock:^(NSString  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger number = strtoul(obj.UTF8String, 0, 16);
        [zoneNumbers insertObject:@(number) atIndex:idx];
    }];
    
    _zoneNumbers = zoneNumbers;
    
    return self;
}

@end

//分片响应
@implementation SRBLEUpdateZoneRsp

- (instancetype)initWithUpdateInfo:(SRBLEUpdateInfo *)info andZoneNumber:(NSInteger)zoneNumber
{
    if (!info || zoneNumber >= info.sectionCount) return nil;
    
    self = [super init];
    
    _zoneNumber = zoneNumber;
    _crcCount = info.dataCheck[zoneNumber];
    _zoneData = info.data[zoneNumber];
    
    return self;
}

- (NSString *)stringValue
{
    return [NSString stringWithFormat:@"%x,%@,%@",
            (UInt8)self.zoneNumber&0xff,
            self.crcCount,
            self.zoneData];
}

@end

//分片校验
@implementation SRBLEUpdateZoneCRCReq : SREntity

- (instancetype)initWithParameters:(NSArray *)parameters
{
    if (!parameters || parameters.count < 2) {
        return nil;
    }
    
    self = [super init];
    
    _zoneNumberStart = strtoul([parameters[0] UTF8String], 0, 16);
    _zoneNumberEnd = strtoul([parameters[1] UTF8String], 0, 16);
    
    return self;
}

@end

//分片校验响应
@implementation SRBLEUpdateZoneCRCRsp : SREntity

- (instancetype)initWithUpdateInfo:(SRBLEUpdateInfo *)info andZoneNumberStart:(NSInteger)zoneNumberStart zoneNumberEnd:(NSInteger)zoneNumberEnd
{
    if (!info || zoneNumberStart >= info.sectionCount || zoneNumberEnd >= info.sectionCount) {
        return nil;
    }
    
    self = [super init];
    
    NSMutableDictionary *zoneCRCs = [NSMutableDictionary dictionary];
    for (NSInteger idx = zoneNumberStart; idx <= zoneNumberEnd; ++idx) {
        [zoneCRCs setObject:info.dataCheck[idx] forKey:@(idx)];
    }
    
    _zoneCRCs = zoneCRCs;
    
    return self;
}

- (NSString *)stringValue {
    NSMutableArray *array = [NSMutableArray array];
    [self.zoneCRCs enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [array addObject:[NSString stringWithFormat:@"%x.%@", (UInt8)key.integerValue&0xff, obj]];
    }];
    
    return [array componentsJoinedByString:@","];
}

@end


