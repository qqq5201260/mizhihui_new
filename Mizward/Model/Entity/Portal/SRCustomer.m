//
//  SRCustomer.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRCustomer.h"
#import "SRPermission.h"
#import "SRMessageSwitchInfo.h"
#import "SRMessageUnreadInfo.h"
#import "SRUserDefaults.h"
#import <MJExtension/MJExtension.h>

@implementation SRCustomer

- (instancetype)init {
    if (self = [super init]) {
        _customerUserName = @"";
        _messageSwitchs = [NSArray array];
        _permissions = [NSArray array];
    }
    
    return self;
}

- (BOOL)isSigned
{
    return self.hasTodaySign && self.signedDate && [self.signedDate isSameDay:[NSDate date]];
}

- (SRMessageSwitchInfo *)messageSwitchWithMessageType:(SRMessageType)messageType
{
    if (!self.messageSwitchs || self.messageSwitchs.count == 0) {
        return nil;
    }
    
    __block SRMessageSwitchInfo *switchInfo;
    [self.messageSwitchs enumerateObjectsUsingBlock:^(SRMessageSwitchInfo *obj, NSUInteger idx, BOOL *stop) {
        if (obj.msgType == messageType) {
            switchInfo = obj;
            *stop = YES;
        }
    }];
    
    return switchInfo;
}

- (NSInteger)unreadMessageCountWithMessageType:(SRMessageType)messageType
{
    if (!self.messageUnread || self.messageUnread.count == 0) {
        return 0;
    }
    
    __block NSInteger count;
    [self.messageUnread enumerateObjectsUsingBlock:^(SRMessageUnreadInfo *obj, NSUInteger idx, BOOL *stop) {
        if (obj.msgType == messageType) {
            count = obj.msgCount;
            *stop = YES;
        }
    }];
    
    return count;
}

- (BOOL)hasUnreadMessageInMessageCenter
{
    return self.hasNewMessageInAlert||self.hasNewMessageInRemind||self.hasNewMessageInFunction;
//    if (!self.messageUnread || self.messageUnread.count == 0) {
//        return NO;
//    }
//    
//    __block BOOL hasUnreadMessage;
//    [self.messageUnread enumerateObjectsUsingBlock:^(SRMessageUnreadInfo *obj, NSUInteger idx, BOOL *stop) {
//        if (obj.msgType != SRMessageType_IM) {
//            hasUnreadMessage = obj.msgCount!=0;
//            *stop = hasUnreadMessage;
//        }
//    }];
//    
//    return hasUnreadMessage;
}

- (BOOL)hasPermissionWithType:(SRPermissionType)type
{
    if (!self.permissions || self.permissions.count == 0) {
        return YES;
    }
    
    __block BOOL hasPermission = YES;
    [self.permissions enumerateObjectsUsingBlock:^(SRPermission *obj, NSUInteger idx, BOOL *stop) {
        if (obj.permissionType == type) {
            hasPermission = obj.value;
            *stop = YES;
        }
    }];
    
    return hasPermission;
    
}

- (NSString *)permissionsString
{
    if (!self.permissions || self.permissions.count == 0) return nil;
    
    NSMutableArray *array = [NSMutableArray array];
    [self.permissions enumerateObjectsUsingBlock:^(SRPermission *obj, NSUInteger idx, BOOL *stop) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj.keyValues options:NSJSONWritingPrettyPrinted error:&error];
        if (!error) {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [array addObject:jsonString];
        }
    }];
    
    return [array componentsJoinedByString:@"*"];
}

- (void)setPermissionsWithString:(NSString *)string
{
    NSArray *jsonArray = [string componentsSeparatedByString:@"*"];
    
    NSMutableArray *permissions = [NSMutableArray array];
    [jsonArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        NSData *jsonData = [obj dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
        if (!error) {
            SRPermission *permission = [SRPermission objectWithKeyValues:dic];
            [permissions addObject:permission];
        }
    }];
    
    self.permissions = permissions;
}

- (NSString *)messageSwitchString
{
    if (!self.messageSwitchs || self.messageSwitchs.count == 0) return nil;
    
    NSMutableArray *array = [NSMutableArray array];
    [self.messageSwitchs enumerateObjectsUsingBlock:^(SRMessageSwitchInfo *obj, NSUInteger idx, BOOL *stop) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj.keyValues options:NSJSONWritingPrettyPrinted error:&error];
        if (!error) {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [array addObject:jsonString];
        }
    }];
    
    return [array componentsJoinedByString:@"*"];
}

- (void)setMessageSwitchsWithString:(NSString *)string
{
    NSArray *jsonArray = [string componentsSeparatedByString:@"*"];
    
    NSMutableArray *switchInfos = [NSMutableArray array];
    [jsonArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        NSData *jsonData = [obj dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
        if (!error) {
            SRMessageSwitchInfo *switchInfo = [SRMessageSwitchInfo objectWithKeyValues:dic];
            [switchInfos addObject:switchInfo];
        }
    }];
    
    self.messageSwitchs = switchInfos;
}

- (NSString *)messageUnreadString
{
    if (!self.messageUnread || self.messageUnread.count == 0) return nil;
    
    NSMutableArray *array = [NSMutableArray array];
    [self.messageUnread enumerateObjectsUsingBlock:^(SRMessageUnreadInfo *obj, NSUInteger idx, BOOL *stop) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj.keyValues options:NSJSONWritingPrettyPrinted error:&error];
        if (!error) {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [array addObject:jsonString];
        }
    }];
    
    return [array componentsJoinedByString:@"*"];
}

- (void)setMessageUnreadWithString:(NSString *)string
{
    NSArray *jsonArray = [string componentsSeparatedByString:@"*"];
    
    NSMutableArray *unreads = [NSMutableArray array];
    [jsonArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        NSData *jsonData = [obj dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
        if (!error) {
            SRMessageUnreadInfo *unread = [SRMessageUnreadInfo objectWithKeyValues:dic];
            [unreads addObject:unread];
        }
    }];
    
    self.messageUnread = unreads;
}

#pragma mark - Setter

- (void)setMessageUnread:(NSArray *)messageUnread {
    _messageUnread = messageUnread;
    
    [self.messageUnread enumerateObjectsUsingBlock:^(SRMessageUnreadInfo *obj, NSUInteger idx, BOOL *stop) {
        
        if (obj.msgCount <= 0) {
            return ;
        }
        
        switch (obj.msgType) {
            case SRMessageType_IM:
                self.hasNewMessageInIm = YES;
                break;
            case SRMessageType_Alert:
                self.hasNewMessageInAlert = YES;
                break;
            case SRMessageType_Remind:
                self.hasNewMessageInRemind = YES;
                break;
            case SRMessageType_Function:
                self.hasNewMessageInFunction = YES;
                break;
                
            default:
//                self.hasNewMessageInIm = YES;
//                self.hasNewMessageInAlert = YES;
//                self.hasNewMessageInRemind = YES;
//                self.hasNewMessageInFunction = YES;
                break;
        }
    }];

}

- (void)setHasTodaySign:(BOOL)hasTodaySign {
    _hasTodaySign = hasTodaySign;
    if (hasTodaySign) {
        self.signedDate = [NSDate date];
    }
}

@end
