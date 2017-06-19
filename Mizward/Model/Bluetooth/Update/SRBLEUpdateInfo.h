//
//  SRBLEUpdateInfo.h
//  Mizward
//
//  Created by zhangjunbo on 15/9/22.
//  Copyright © 2015年 Mizward. All rights reserved.
//

#import "SREntity.h"

#pragma mark - Server

//从服务器获取的硬件升级信息
@interface SRBLEUpdateInfo : SREntity

@property (nonatomic, assign)   NSInteger   byteSize;   //总字节数
@property (nonatomic, strong)   NSArray     *data;      //分片数据
@property (nonatomic, strong)   NSArray     *dataCheck; //分片数据CRC
@property (nonatomic, assign)   NSInteger   sectionCount;//分片数目
@property (nonatomic, assign)   NSInteger   sectionSize;//每个分片字节数
@property (nonatomic, copy)     NSString    *totalCheck;//总校验

@end

#pragma mark - BTU

//配置升级
@interface SRBLEUpdateFirmwareConfig  : SREntity

@property (nonatomic, copy) NSString *productName;      //产品名称
@property (nonatomic, copy) NSString *hardwareVersion;  //硬件版本
@property (nonatomic, copy) NSString *zoneFormat;       //分区格式
@property (nonatomic, copy) NSString *softwareName;     //软件名称
@property (nonatomic, copy) NSString *compileType;      //编译类型
@property (nonatomic, copy) NSString *softwareVersion;  //软件版本

- (NSString *)stringValue;

@end

//固件请求
@interface SRBLEUpdateFirmwareReq : SREntity

@property (nonatomic, assign) NSInteger sectionNumber;  //扇区编号
@property (nonatomic, assign) NSInteger sectionVersion; //扇区当前软件版本
@property (nonatomic, assign) NSInteger zoneLength;     //分片长度
@property (nonatomic, assign) NSInteger firmwareVersion;//引导固件版本

- (instancetype)initWithParameters:(NSArray *)parameters;

@end

//固件响应
@interface SRBLEUpdateFirmwareRsp : SREntity

@property (nonatomic, assign) NSInteger byteSize;       //字节总数
@property (nonatomic, assign) NSInteger sectionCount;   //分片总数
@property (nonatomic, copy) NSString *crcCount;       //校验和

- (instancetype)initWithUpdateInfo:(SRBLEUpdateInfo *)info;

- (NSString *)stringValue;

@end

//分片请求
@interface SRBLEUpdateZoneReq : SREntity

@property (nonatomic, strong) NSArray *zoneNumbers;     //分片编号

- (instancetype)initWithParameters:(NSArray *)parameters;

@end

//分片响应
@interface SRBLEUpdateZoneRsp : SREntity

@property (nonatomic, assign) NSInteger zoneNumber;     //分片编号
@property (nonatomic, copy) NSString *crcCount;       //校验和
@property (nonatomic, copy) NSString *zoneData;         //数据

- (instancetype)initWithUpdateInfo:(SRBLEUpdateInfo *)info andZoneNumber:(NSInteger)zoneNumber;

- (NSString *)stringValue;

@end

//分片校验请求
@interface SRBLEUpdateZoneCRCReq : SREntity

@property (nonatomic, assign) NSInteger zoneNumberStart;     //分片编号起始
@property (nonatomic, assign) NSInteger zoneNumberEnd;      //分片编号结束

- (instancetype)initWithParameters:(NSArray *)parameters;

@end

//分片校验响应
@interface SRBLEUpdateZoneCRCRsp : SREntity

@property (nonatomic, strong) NSDictionary *zoneCRCs;     //分片编号

- (instancetype)initWithUpdateInfo:(SRBLEUpdateInfo *)info andZoneNumberStart:(NSInteger)zoneNumberStart zoneNumberEnd:(NSInteger)zoneNumberEnd;

- (NSString *)stringValue;

@end


