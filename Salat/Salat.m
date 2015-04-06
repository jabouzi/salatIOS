//
//  Salat.m
//  Salat
//
//  Created by Skander Jabouzi on 2015-01-21.
//  Copyright (c) 2015 Skander Jabouzi. All rights reserved.
//

#import "Salat.h"

@implementation Salat

- (id)init
{
    self = [super init];
    if (self)
    {

        PI = 4.0*atan(1.0);
        // Calculation Methods
        Jafari     = 0;    // Ithna Ashari
        Karachi    = 1;    // University of Islamic Sciences, Karachi
        ISNA       = 2;    // Islamic Society of North America (ISNA)
        MWL        = 3;    // Muslim World League (MWL)
        Makkah     = 4;    // Umm al-Qura, Makkah
        Egypt      = 5;    // Egyptian General Authority of Survey
        Tehran     = 6;    // Institute of Geophysics, University of Tehran
        Custom     = 7;    // Custom Setting
        
        // Juristic Methods
        Shafii     = 0;    // Shafii (standard)
        Hanafi     = 1;    // Hanafi
        
        // Adjusting Methods for Higher Latitudes
        None       = 0;    // No adjustment
        MidNight   = 1;    // middle of night
        OneSeventh = 2;    // 1/7th of night
        AngleBased = 3;    // angle/60th of night
        
        
        // Time Formats
        Time24     = 0;    // 24-hour format
        Time12     = 1;    // 12-hour format
        Time12NS   = 2;    // 12-hour format with no suffix
        Float      = 3;    // floating point number
        
        // Time Names
        //timeNames = {'Fajr','Sunrise','Dhuhr','Asr','Sunset','Maghrib','Isha'};
        
        InvalidTime = @"-----";     // The string used for invalid times
        
        
        //---------------------- Global Variables --------------------
        
        
        calcMethod   = 0;        // caculation method
        asrJuristic  = 0.0;        // Juristic method for Asr
        dhuhrMinutes = 0.0;        // minutes after mid-day for Dhuhr
        adjustHighLats = 0;    // adjusting method for higher latitudes
        
        timeFormat   = 0;        // time format
        
        
        //--------------------- Technical Settings --------------------
        
        
        numIterations = 1;        // number of iterations needed to compute times
        
        methodParams[0][0] = 16.0;
        methodParams[0][1] = 0.0;
        methodParams[0][2] = 4.0;
        methodParams[0][3] = 0.0;
        methodParams[0][4] = 14.0;
        
        methodParams[1][0] = 18.0;
        methodParams[1][1] = 1.0;
        methodParams[1][2] = 0.0;
        methodParams[1][3] = 0.0;
        methodParams[1][4] = 18.0;
        
        methodParams[2][0] = 15.0;
        methodParams[2][1] = 1.0;
        methodParams[2][2] = 0.0;
        methodParams[2][3] = 0.0;
        methodParams[2][4] = 15.0;
        
        methodParams[3][0] = 18.0;
        methodParams[3][1] = 1.0;
        methodParams[3][2] = 0.0;
        methodParams[3][3] = 0.0;
        methodParams[3][4] = 17.0;
        
        methodParams[4][0] = 19.0;
        methodParams[4][1] = 1.0;
        methodParams[4][2] = 0.0;
        methodParams[4][3] = 1.0;
        methodParams[4][4] = 90.0;
        
        methodParams[5][0] = 19.5;
        methodParams[5][1] = 1.0;
        methodParams[5][2] = 0.0;
        methodParams[5][3] = 0.0;
        methodParams[5][4] = 17.5;
        
        methodParams[6][0] = 18.0;
        methodParams[6][1] = 1.0;
        methodParams[6][2] = 0.0;
        methodParams[6][3] = 0.0;
        methodParams[6][4] = 17.0;
        
        methodParams[7][0] = 17.7;
        methodParams[7][1] = 0.0;
        methodParams[7][2] = 4.5;
        methodParams[7][3] = 0.0;
        methodParams[7][4] = 15.0;
        
        times = [[NSMutableArray alloc] initWithCapacity:7];
        
    }
    return self;
}

- (void)getDatePrayerTimes:(int)year :(int)month :(int)day :(double)latitude :(double)longitude :(double)timeZone :(NSMutableArray *)prayerTimes
{
    lat = latitude;
    lng = longitude;
    timezone = timeZone;
    //timeZone = effectiveTimeZone(year, month, day, timeZone);
    JDate = julianDate(year, month, day)- longitude/ (15* 24);
    [self computeDayTimes:prayerTimes];
}

// set the calculation method
- (void) setCalcMethod:(int)methodID
{
    calcMethod = methodID;
}

// set the juristic method for Asr
- (void) setAsrMethod:(int)methodID
{
    if (methodID < 0 || methodID > 1)
        return;
    asrJuristic = methodID;
}

// set the angle for calculating Fajr
- (void) setFajrAngle:(double)angle
{
    double *customParams[] = {&angle, NULL, NULL, NULL, NULL};
    setCustomParams(customParams);
}

// set the angle for calculating Maghrib
- (void) setMaghribAngle:(double)angle
{
    double *customParams[] = {NULL, 0, &angle, NULL, NULL};
    setCustomParams(customParams);
}

// set the angle for calculating Isha
- (void) setIshaAngle:(double)angle
{
    double *customParams[] = {NULL, NULL, NULL, 0, &angle};
    setCustomParams(customParams);
}

// set the minutes after mid-day for calculating Dhuhr
- (void) setDhuhrMinutes:(int)minutes
{
    dhuhrMinutes = minutes;
}

// set the minutes after Sunset for calculating Maghrib
- (void) setMaghribMinutes:(int)minutes
{
    double *customParams[] = {NULL, 1, &minutes, NULL, NULL};
    setCustomParams(customParams);
}

// set the minutes after Maghrib for calculating Isha
- (void) setIshaMinutes:(int)minutes
{
    double *customParams[] = {NULL, 1, &minutes, NULL, NULL};
    setCustomParams(customParams);
}

// set custom values for calculation parameters
- (void) setCustomParams:(NSArray*)params
{
    for (int i=0; i<5; i++)
    {
        if ([params objectAtIndex:i] == nil)
            methodParams[Custom][i] = methodParams[calcMethod][i];
        else
            methodParams[Custom][i] = [[params objectAtIndex:3] integerValue];
    }
    calcMethod = Custom;
}

// set adjusting method for higher latitudes
- (void) setHighLatsMethod:(int)methodID
{
    adjustHighLats = methodID;
}

// set the time format
- (void) setTimeFormat:(int)timeFormat
{
    timeFormat = timeFormat;
}

// convert float hours to 24h format
- (NSString*) floatToTime24:(double)time
{
    if (isNaN(time))
        return InvalidTime;
    else{
        time = fixhour(time+ 0.5/ 60);  // add 0.5 minutes to round
        double hours = floor(time);
        double minutes = floor((time- hours)* 60);
        return [NSString stringWithFormat:@"%@%@%@",[self twoDigitsFormat:hours], @":", [self twoDigitsFormat:minutes]];
    }
}

// convert float hours to 12h format
- (NSString*) floatToTime12:(double)time
{
    if (isNaN(time))
        return InvalidTime;
    else{
        time = fixhour(time+ 0.5/ 60);  // add 0.5 minutes to round
        int hours = ((int)time);
        int minutes = (((int)time- hours)* 60);
        NSString *suffix = [NSString stringWithFormat:@"%@", (hours >= 12.0 ? @" pm" : @" am")];
        hours = (hours + 12 - 1) % 12 + 1;
        return [NSString stringWithFormat:@"%d%@%@%@", hours, @":", [self twoDigitsFormat:minutes], suffix];
    }

}
                
// compute declination angle of sun and equation of time
- (double) sunPosition:(double)jd :(int)flag
{
    double D = jd - 2451545.0;
    double g = fixangle(357.529 + 0.98560028* D);
    double q = fixangle(280.459 + 0.98564736* D);
    double L = fixangle(q + 1.915* dsin(g) + 0.020* dsin(2*g));
    
    //double R = 1.00014 - 0.01671* dcos(g) - 0.00014* dcos(2*g);
    double e = 23.439 - 0.00000036* D;
    
    double d = darcsin(dsin(e)* dsin(L));
    double RA = darctan2(dcos(e)* dsin(L), dcos(L))/ 15;
    RA = fixhour(RA);
    double EqT = q/15 - RA;
    //double * result = new double[2];
    if (flag == 0) return d;
    return EqT;
}
                
// compute equation of time
- (double) equationOfTime:(double)jd
{
    return [self sunPosition:jd:1];
}
                
// compute declination angle of sun
- (double) sunDeclination:(double)jd
{
    return [self sunPosition:jd:0];
}
                
// compute mid-day (Dhuhr, Zawal) time
- (double) computeMidDay:(double)t
{
    double T = [self equationOfTime:(JDate + t)];
    double Z = [self fixhour:(12 - T)];
    return Z;
}
                
// compute time for a given angle G
- (double) computeTime:(double)G :(double)t
{
    double D = [self sunDeclination:(JDate + t)];
    double Z = [self computeMidDay:t];
    double V = 1.0/15.0* [self darccos:((-[self dsin:G] -[self dsin:D] * [self dsin:lat]) / ([self dcos:D] * [self dcos:lat]))];
    return Z + (G > 90.0 ? -V : V);
}
                
// compute the time of Asr
- (double) computeAsr:(int)step :(double)t
{
    
}// Shafii: step=1, Hanafi: step=2

                
//---------------------- Compute Prayer Times -----------------------
                
                
// compute prayer times at given julian date
- (void) computeTimes:(NSArray*)times
{
    
}
                
// compute prayer times at given julian date
- (void) computeDayTimes:(NSMutableArray*)prayerTimes
{
    
}
 
// adjust times in a prayer time array
- (void) adjustTimes:(NSArray*)times
{
    
}
 
// convert times array to given time format
- (void) adjustTimesFormat:(NSArray*)times :(NSMutableArray*)prayerTimes
{
     
}
 
// adjust Fajr, Isha and Maghrib for locations in higher latitudes
- (void) adjustHighLatTimes:(NSArray*)times
{
    
}
 
// the night portion used for adjusting times in higher latitudes
- (double) nightPortion:(NSArray*)times
{
    
}
 
// convert hours to day portions
- (void) dayPortion:(NSArray*)times
{
    
}
  
//---------------------- Misc Functions -----------------------
 
 
// compute the difference between two times
- (double) timeDiff:(double)time1 : (double)time2
{
    
}
                
// add a leading 0 if necessary
- (NSString*) twoDigitsFormat:(int)num
{
    
}
  
//bool isNaN(int);
  
  
//bool isNaN(float);
                
 
- (BOOL) isNaN:(double)var
{
     
}
 
 //---------------------- Julian Date Functions -----------------------
 
 
// calculate julian date from a calendar date
- (double) julianDate:(int)year :(int)month :(int)day
{
    
}
  
//---------------------- Trigonometric Functions -----------------------
  
  
// degree sin
- (double) dsin:(double)d
{
     
}
    
// degree cos
- (double) dcos:(double)d
{
    
}

// degree tan
- (double) dtan:(double)d
{
    
}
  
// degree arcsin
- (double) darcsin:(double)x
{
    
}

// degree arccos
- (double) darccos:(double)x
{
    
}
  
// degree arctan
- (double) darctan:(double)x
{
    
}
  
// degree arctan2
- (double) darctan2:(double)y :(double)x
{
    
}
  
// degree arccot
- (double) darccot:(double)x
{
    
}

// degree to radian
- (double) dtr:(double)d
{
    
}
 
// radian to degree
- (double) rtd:(double)r
{
    
}
 
 // range reduce angle in degrees.
- (double) fixangle:(double)a
{
    
}
 
// range reduce hours to 0..23
- (double) fixhour:(double)a
{
    
}



@end
