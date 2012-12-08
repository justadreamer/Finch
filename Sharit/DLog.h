/*
 *  DLog.h
 *  LifelikeClassifieds
 *
 *  Created by Eugene Dorfman on 10/6/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */


//
// DLog is almost a drop-in replacement for NSLog
// DLog();
// DLog(@"here");
// DLog(@"value: %d", x);
// Unfortunately this doesn't work DLog(aStringVariable); you have to do this instead DLog(@"%@", aStringVariable);
//
#ifdef DEBUG
#	define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#	define DLog(...)
#endif

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

//Convenience macros, to output just one value of certain type:
#define VLog(v) DLog(@#v @"=%@",v)
#define fLog(v) DLog(@#v @"=%f",v)
#define dLog(v) DLog(@#v @"=%d",v)

//Convenience macro to output CGRect value in a human readable format:
#define CGRectLog(v) DLog(@#v @"=(%f,%f,%f,%f)",v.origin.x,v.origin.y,v.size.width,v.size.height)
#define CGSizeLog(v) DLog(@#v @"=(%f,%f)",v.width,v.height)
#define CGPointLog(v) DLog(@#v @"=(%f,%f)",v.x,v.y)

//for ALog
#define CGRectALog(v) ALog(@#v @"=(%f,%f,%f,%f)",v.origin.x,v.origin.y,v.size.width,v.size.height)
#define CGSizeALog(v) ALog(@#v @"=(%f,%f)",v.width,v.height)
#define CGPointALog(v) ALog(@#v @"=(%f,%f)",v.x,v.y)

#define INVOKED DLog (@"")