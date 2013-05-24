
#import "Epolys.h"

@implementation Epolys

+ (float)distanceFrom:(CLLocationCoordinate2D)latLngFrom to:(CLLocationCoordinate2D)latLngTo {
    
    float EarthRadiusMeters = 6378137.0; // meters

    float dLat = (latLngTo.latitude - latLngFrom.latitude) * M_PI / 180;
    float dLon = (latLngTo.longitude - latLngFrom.longitude) * M_PI / 180;
    
    float a = sin(dLat/2) * sin(dLat/2) + cos(latLngFrom.latitude * M_PI / 180 ) * cos(latLngTo.latitude * M_PI / 180 ) * sin(dLon/2) * sin(dLon/2);
    float c = 2 * atan2(sqrt(a), sqrt(1-a));
    float d = EarthRadiusMeters * c;
    
    return d;
}

+ (float)distancePath:(NSArray *)path {
    
    float distance = 0.0f;
    
    for(int i = 1;i < [path count];i++){
        
        CLLocation *locationFrom = [path objectAtIndex:i];
        CLLocation *locationTo = [path objectAtIndex:i - 1];
        
        distance += [self distanceFrom:locationFrom.coordinate to:locationTo.coordinate];
    }
        
    return distance;
}

+ (CLLocationCoordinate2D)getPointAtDistance:(float)meters forPath:(NSArray *)path mapView:(RMMapView *)mapView {
    
    CLLocation *point;
    
    if (meters == 0) point = [path objectAtIndex:0];
    if (meters < 0) point = nil;
    if ([path count] < 2) point = nil;
    
    float distance = 0;
    float oldDistance = 0;
    int i;
    
    for (i = 1; (i < [path count] && distance < meters); i++) {
        
        CLLocation *locationFrom = [path objectAtIndex:i];
        CLLocation *locationTo = [path objectAtIndex:i - 1];
        
        distance += [self distanceFrom:locationFrom.coordinate to:locationTo.coordinate];
    }
    
    if (distance < meters) {
        CLLocation *l = [path objectAtIndex:i];
        return l.coordinate;
    }

    CLLocation *pl1 = [path objectAtIndex:i - 2];
    CLLocation *pl2 = [path objectAtIndex:i - 1];
    
    RMProjectedPoint p1= [mapView coordinateToProjectedPoint:pl1.coordinate];
    RMProjectedPoint p2 = [mapView coordinateToProjectedPoint:pl2.coordinate];
    float m = (meters - oldDistance) / (distance - oldDistance);
    
    return [mapView projectedPointToCoordinate:RMProjectedPointMake(p1.x + (p2.x - p1.x ) * m , p1.y + (p2.y - p1.y) * m)];
}

@end
