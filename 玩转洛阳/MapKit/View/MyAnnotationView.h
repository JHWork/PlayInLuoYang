//
//  MyAnnotationView.h
//  玩转洛阳
//
//  Created by 小尼 on 15/10/19.
//  Copyright © 2015年 N. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MyAnnotationView : MKAnnotationView

+ (instancetype)myAnnoViewWithMapView:(MKMapView *)mapView;

@end
