//
//  XMRequest.m
//  MaptimizeKit
//
//  Created by Oleg Shnitko on 4/23/10.
//  olegshnitko@gmail.com
//  
//  Copyright © 2010 Screen Customs s.r.o. All rights reserved.
//

#import "XMBase.h"

#import "XMRequest.h"

#import "XMNetworkUtils.h"
#import "XMCondition.h"

#import "XMLog.h"

#define	BASE_URL	@"http://v2.maptimize.com/api/v2-0"
#define URL_FORMAT	@"%@/%@/%@?%@&z=%d"

#define PARAM_FORMAT @"&%@=%@"

const NSString *kXMDistance	=	@"d";

const NSString *kXMProperties	=	@"p";
const NSString *kXMAggreagtes	=	@"a";
const NSString *kXMCondition	=	@"c";
const NSString *kXMGroupBy		=	@"g";

const NSString *kXMLimit		=	@"l";
const NSString *kXMOffset		=	@"o";

const NSString *kXMOrder		=	@"order";

@interface XMRequest (Private)

+ (NSURL *)urlForMapKey:(NSString *)mapKey
				 method:(NSString *)method
				 bounds:(XMBounds)bounds
			  zoomLevel:(NSUInteger)zoomLevel
				 params:(NSDictionary *)params;

+ (NSString *)stringForParams:(NSDictionary *)params;

@end

@implementation XMRequest

- (id)initWithMapKey:(NSString *)mapKey
			  method:(NSString *)method
			  bounds:(XMBounds)bounds
		   zoomLevel:(NSUInteger)zoomLevel
			  params:(NSDictionary *)parmas
{
	NSURL *anUrl = [XMRequest urlForMapKey:mapKey method:method bounds:bounds zoomLevel:zoomLevel params:parmas];
	if (self = [super initWithURL:anUrl])
	{
		[self addRequestHeader:@"User-Agent" value:@"MaptimizeKit-iPhone"];
		[self addRequestHeader:@"accept" value:@"application/json"];
	}
	
	return self;
}

+ (NSURL *)urlForMapKey:(NSString *)mapKey
				 method:(NSString *)method
				 bounds:(XMBounds)bounds
			  zoomLevel:(NSUInteger)zoomLevel
				 params:(NSDictionary *)params
{
	NSString *boundsString = XMStringFromXMBounds(bounds);
	
	NSString *commonString = [NSString stringWithFormat:URL_FORMAT, BASE_URL, mapKey, method, boundsString, zoomLevel];
	NSString *paramsString = [XMRequest stringForParams:params];
	
	NSString *urlString = [NSString stringWithFormat:@"%@%@", commonString, paramsString];
	
	NSURL *url = [[NSURL alloc] initWithString:urlString];
	
	XM_LOG_TRACE(@"url: %@", url);
	
	return [url autorelease];
}

+ (NSString *)stringForParams:(NSDictionary *)params
{
	NSMutableString *paramsString =  [NSMutableString stringWithString:@""];
	
	NSObject *distance = [params objectForKey:kXMDistance];
	if ([distance isKindOfClass:[NSNumber class]])
	{
		[paramsString appendFormat:PARAM_FORMAT, kXMDistance, distance];
	}
	
	NSObject *properties = [params objectForKey:kXMProperties];
	if ([properties isKindOfClass:[NSString class]])
	{
		NSString *propertiesString = (NSString *)properties;
		[paramsString appendFormat:PARAM_FORMAT, kXMProperties, XMEncodedStringFromString(propertiesString)];
	}
	else if ([properties isKindOfClass:[NSArray class]])
	{
		NSArray *propertiesArray = (NSArray *)properties;
		NSString *propertiesString = [propertiesArray componentsJoinedByString:@","];
		[paramsString appendFormat:PARAM_FORMAT, kXMProperties, XMEncodedStringFromString(propertiesString)];
	}
	
	NSObject *aggregates = [params objectForKey:kXMAggreagtes];
	if ([aggregates isKindOfClass:[NSString class]])
	{
		NSString *aggregatesString = (NSString *)aggregates;
		[paramsString appendFormat:PARAM_FORMAT, kXMAggreagtes, XMEncodedStringFromString(aggregatesString)];
	}
	
	NSObject *condition = [params objectForKey:kXMCondition];
	if ([condition isKindOfClass:[NSString class]] || [condition isKindOfClass:[XMCondition class]])
	{
		NSString *conditionString = [NSString stringWithFormat:@"%@", condition];
		[paramsString appendFormat:PARAM_FORMAT, kXMCondition, XMEncodedStringFromString(conditionString)];
	}
	
	NSObject *groupBy = [params objectForKey:kXMGroupBy];
	if ([groupBy isKindOfClass:[NSString class]])
	{
		NSString *groupByString = (NSString *)groupBy;
		[paramsString appendFormat:PARAM_FORMAT, kXMGroupBy, XMEncodedStringFromString(groupByString)];
	}
	
	NSObject *limit = [params objectForKey:kXMLimit];
	if ([limit isKindOfClass:[NSNumber class]])
	{
		[paramsString appendFormat:PARAM_FORMAT, kXMLimit, limit];
	}
	
	NSObject *offset = [params objectForKey:kXMOffset];
	if ([offset isKindOfClass:[NSNumber class]])
	{
		[paramsString appendFormat:PARAM_FORMAT, kXMOffset, offset];
	}
	
	NSObject *order = [params objectForKey:kXMOrder];
	if ([order isKindOfClass:[NSString class]])
	{
		[paramsString appendFormat:PARAM_FORMAT, kXMOrder, order];
	}
	
	return paramsString;
}

@end
