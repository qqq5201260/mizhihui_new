
//
//  FZKBVisitorLoginHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBVisitorLoginHttpAction : FZKHttpWork
    
/**
 方法描述：
 游客登录
 
 传入参数
input1：用户名
input2：用户密码（两参数都需加密）
返回值
bindingStatus：账户绑定状态 0：未绑定 1：已绑定，且当前用户为绑定用户 2：已绑定，当前用户不是绑定用户
customerType：账户类型 0：正常用户 2：体验用户
endPoints：endPoints列表
updateVersion：APP最新版本号
token：APP登陆token，供4S在线接口使用
department：部门（4S店）信息
depPartAttr：部门属性
levelCode：部门层级
name：部门名称
address：地址
assistPhone：救援电话
createTime：登录时间
createUserID：登陆者id
depID：部门id
siruiOnlineName:4S在线广告语
lat:经度
lng：维度
notifyDangerPhone：客服电话
serverPhone：服务电话
customer：用户信息
customerID：用户id
customerName:用户账号
customerPhone：用户电话
customerSex：用户性别1：男 2：女
cars：车信息
brandID：经营品牌ID
brandName：品牌名
terminalID;//终端ID
plateNumber;//车牌号
vehicleModelName;//车辆类型名称
serviceEndTime:服务结束时间
needUpdate：是否需要更新true：是false：不需要
resultCode：结果码，0：成功，其它：失败
resultMessage：返回结果信息

 */
- (void)visitorLoginActionWithInput1:(NSString *)input1 input2:(NSString *)input2;

@end