//
//  CoordinateTransform.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/4.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#ifndef SiRuiV4_0_CoordinateTransform_h
#define SiRuiV4_0_CoordinateTransform_h

#import <CoreLocation/CoreLocation.h>

CLLocationCoordinate2D transformFromWGSToGCJ(CLLocationCoordinate2D wgLoc);
CLLocationCoordinate2D bd_encrypt(CLLocationCoordinate2D gcjLoc);
CLLocationCoordinate2D bd_decrypt(CLLocationCoordinate2D bdLoc);


#endif
