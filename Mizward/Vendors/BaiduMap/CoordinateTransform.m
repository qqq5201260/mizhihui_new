//
//  CoordinateTransform.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/4.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoordinateTransform.h"

///
///  Transform WGS-84 to GCJ-02 (Chinese encrypted coordination system)
///

const double pi = 3.14159265358979324;

//
// Krasovsky 1940
//
// a = 6378245.0, 1/f = 298.3
// b = a * (1 - f)
// ee = (a^2 - b^2) / a^2;
const double a = 6378245.0;
const double ee = 0.00669342162296594323;

int outOfChina(double lat, double lon)
{
    if (lon < 72.004 || lon > 137.8347)
        return 1;
    if (lat < 0.8293 || lat > 55.8271)
        return 1;
    return 0;
}

double transformLat(double x, double y)
{
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(x > 0 ? x:-x);
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 *sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
    return ret;
}

double transformLon(double x, double y)
{
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(x > 0 ? x:-x);
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
    return ret;
}

CLLocationCoordinate2D transformFromWGSToGCJ(CLLocationCoordinate2D wgLoc)
{
    CLLocationCoordinate2D mgLoc;
    if (outOfChina(wgLoc.latitude, wgLoc.longitude))
    {
        mgLoc = wgLoc;
        return mgLoc;
    }
    double dLat = transformLat(wgLoc.longitude - 105.0, wgLoc.latitude - 35.0);
    double dLon = transformLon(wgLoc.longitude - 105.0, wgLoc.latitude - 35.0);
    double radLat = wgLoc.latitude / 180.0 * pi;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
    mgLoc.latitude = wgLoc.latitude + dLat;
    mgLoc.longitude = wgLoc.longitude + dLon;
    
    return mgLoc;
}

///
///  Transform GCJ-02 to BD-09
///
const double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
CLLocationCoordinate2D bd_encrypt(CLLocationCoordinate2D gcLoc)
{
    if (outOfChina(gcLoc.latitude, gcLoc.longitude)) {
        return gcLoc;
    }
    double x = gcLoc.longitude, y = gcLoc.latitude;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    return CLLocationCoordinate2DMake(z * sin(theta) + 0.006, z * cos(theta) + 0.0065);
}

///
///  Transform BD-09 to GCJ-02
///
CLLocationCoordinate2D bd_decrypt(CLLocationCoordinate2D bdLoc)
{
    double x = bdLoc.longitude - 0.0065, y = bdLoc.longitude - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    return CLLocationCoordinate2DMake(z * sin(theta), z * cos(theta));
}

