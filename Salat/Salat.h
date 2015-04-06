//
//  Salat.h
//  Salat
//
//  Created by Skander Jabouzi on 2015-01-21.
//  Copyright (c) 2015 Skander Jabouzi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Salat : NSObject
{
    NSMutableArray *times;
    NSMutableArray *prayerTimes;
    double PI;
    
    int Jafari;    // Ithna Ashari
    int Karachi;    // University of Islamic Sciences, Karachi
    int ISNA;    // Islamic Society of North America (ISNA)
    int MWL;    // Muslim World League (MWL)
    int Makkah;    // Umm al-Qura, Makkah
    int Egypt;    // Egyptian General Authority of Survey
    int Tehran;    // Institute of Geophysics, University of Tehran
    int Custom;    // Custom Setting
    
    // Juristic Methods
    int Shafii;    // Shafii (standard)
    int Hanafi;    // Hanafi
    
    // Adjusting Methods for Higher Latitudes
    int None;    // No adjustment
    int MidNight;    // middle of night
    int OneSeventh;    // 1/7th of night
    int AngleBased;    // angle/60th of night
    
    
    // Time Formats
    int Time24;    // 24-hour format
    int Time12;    // 12-hour format
    int Time12NS;    // 12-hour format with no suffix
    int Float;    // floating point number
    
    // Time Names
    //NSString timeNames[7];
    
    NSString *InvalidTime;	 // The string used for invalid times
    
    
    //---------------------- Global Variables --------------------
    
    
    int calcMethod;		// caculation method
    int asrJuristic;		// Juristic method for Asr
    int dhuhrMinutes;		// minutes after mid-day for Dhuhr
    int adjustHighLats;	// adjusting method for higher latitudes
    
    int timeFormat;		// time format
    
    double lat;        // latitude
    double lng;        // longitude
    double timezone;   // time-zone
    double JDate;      // Julian date
    
    
    //--------------------- Technical Settings --------------------
    
    
    int numIterations;		// number of iterations needed to compute times
    
    
    
    
    //------------------- Calc Method Parameters --------------------
    
    double methodParams[8][5];
    //NSArray *methodParams;

}

- (void)getDatePrayerTimes:(int)year :(int)month :(int)day :(double)latitude :(double)longitude :(double)timeZone;


// set the calculation method
- (void) setCalcMethod:(int)methodID;

// set the juristic method for Asr
- (void) setAsrMethod:(int)methodID;


// set the angle for calculating Fajr
- (void) setFajrAngle:(double)angle;


// set the angle for calculating Maghrib
- (void) setMaghribAngle:(double)angle;

// set the angle for calculating Isha
- (void) setIshaAngle:(double)angle;


// set the minutes after mid-day for calculating Dhuhr
- (void) setDhuhrMinutes:(int)minutes;


// set the minutes after Sunset for calculating Maghrib
- (void) setMaghribMinutes:(int)minutes;


// set the minutes after Maghrib for calculating Isha
- (void) setIshaMinutes:(int)minutes;


// set custom values for calculation parameters
- (void) setCustomParams:(NSArray*)params;


// set adjusting method for higher latitudes
- (void) setHighLatsMethod:(int)methodID;


// set the time format
- (void) setTimeFormat:(int)timeFormat;


// convert float hours to 24h format
- (NSString*) floatToTime24:(double)time;


// convert float hours to 12h format
- (NSString*) floatToTime12:(double)time;



//---------------------- Calculation Functions -----------------------

// References:
// http://www.ummah.net/astronomy/saltime
// http://aa.usno.navy.mil/faq/docs/SunApprox.html


// compute declination angle of sun and equation of time
- (double) sunPosition:(double)jd :(int)flag;


// compute equation of time
- (double) equationOfTime:(double)jd;


// compute declination angle of sun
- (double) sunDeclination:(double)jd;


// compute mid-day (Dhuhr, Zawal) time
- (double) computeMidDay:(double)t;


// compute time for a given angle G
- (double) computeTime:(double)G :(double)t;


// compute the time of Asr
- (double) computeAsr:(int)step :(double)t;  // Shafii: step=1, Hanafi: step=2



//---------------------- Compute Prayer Times -----------------------


// compute prayer times at given julian date
- (void) computeTimes;


// compute prayer times at given julian date
- (void) computeDayTimes;



// adjust times in a prayer time array
- (void) adjustTimes;



// convert times array to given time format
- (void) adjustTimesFormat;



// adjust Fajr, Isha and Maghrib for locations in higher latitudes
- (void) adjustHighLatTimes;



// the night portion used for adjusting times in higher latitudes
- (double) nightPortion:(double)angle;



// convert hours to day portions
- (void) dayPortion;




//---------------------- Misc Functions -----------------------


// compute the difference between two times
- (double) timeDiff:(double)time1 : (double)time2;



// add a leading 0 if necessary
- (NSString*) twoDigitsFormat:(int)num;


//bool isNaN(int);


//bool isNaN(float);


- (BOOL) isNaN:(double)var;

//---------------------- Julian Date Functions -----------------------


// calculate julian date from a calendar date
- (double) julianDate:(int)year :(int)month :(int)day;


//---------------------- Time-Zone Functions -----------------------


// compute local time-zone for a specific date
/*- (void) getTimeZone(QDate date);
 
 
 
 // compute base time-zone of the system
 - (void) getBaseTimeZone();
 
 
 
 // detect daylight saving in a given date
 - (void) detectDaylightSaving(QDate date);*/



// return effective timezone for a given date
//- (void) effectiveTimeZone(int year, int month, int day, int timeZone);



//---------------------- Trigonometric Functions -----------------------


// degree sin
- (double) dsin:(double)d;


// degree cos
- (double) dcos:(double)d;


// degree tan
- (double) dtan:(double)d;


// degree arcsin
- (double) darcsin:(double)x;


// degree arccos
- (double) darccos:(double)x;


// degree arctan
- (double) darctan:(double)x;


// degree arctan2
- (double) darctan2:(double)y :(double)x;


// degree arccot
- (double) darccot:(double)x;


// degree to radian
- (double) dtr:(double)d;


// radian to degree
- (double) rtd:(double)r;


// range reduce angle in degrees.
- (double) fixangle:(double)a;


// range reduce hours to 0..23
- (double) fixhour:(double)a;



/*  methodParams[methodNum] = new Array(fa, ms, mv, is, iv);
 
 fa : fajr angle
 ms : maghrib selector (0 = angle; 1 = minutes after sunset)
 mv : maghrib parameter value (in angle or minutes)
 is : isha selector (0 = angle; 1 = minutes after maghrib)
 iv : isha parameter value (in angle or minutes)
 */

- (void)showSalats;

@end
