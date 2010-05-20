//
//  XMBounds.h
//  MaptimizeKit
//
//  Created by Oleg Shnitko on 4/23/10.
//  olegshnitko@gmail.com
//  
//  Copyright © 2010 Screen Customs s.r.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#import "XMBase.h"

struct _XMBounds
{
	CLLocationCoordinate2D sw;
	CLLocationCoordinate2D ne;
};
typedef struct _XMBounds XMBounds;

XM_INLINE
XMBounds XMBoundsMake(CLLocationDegrees swLat, CLLocationDegrees swLng, CLLocationDegrees neLat, CLLocationDegrees neLng)
{
	XMBounds bounds;
	bounds.sw.latitude = swLat;
	bounds.sw.longitude = swLng;
	bounds.ne.latitude = neLat;
	bounds.ne.longitude = neLng;
	return bounds;
}

XM_EXTERN NSString *NSStringFromXMBounds(XMBounds bounds);
XM_EXTERN NSString *XMStringFromXMBounds(XMBounds bounds);