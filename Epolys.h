
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapBox/MapBox.h>

@interface Epolys : NSObject

+ (float)distanceFrom:(CLLocationCoordinate2D)latLngFrom to:(CLLocationCoordinate2D)latLngTo;
+ (float)distancePath:(NSArray *)path;
+ (CLLocationCoordinate2D)getPointAtDistance:(float)meters forPath:(NSArray *)path mapView:(RMMapView *)mapView;

@end
