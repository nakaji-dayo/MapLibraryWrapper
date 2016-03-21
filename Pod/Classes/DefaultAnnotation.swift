//
//  DefaultAnotation.swift
//  beer-app-ios
//
//  Created by daishi nakajima on 2016/02/22.
//  Copyright © 2016年 daishi nakajima. All rights reserved.
//

import UIKit
import MapKit

class DefaultAnnotation : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var userData: AnyObject?
    var image: UIImage?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
}