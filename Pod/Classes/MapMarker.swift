//
//  MapMarker.swift
//  beer-app-ios
//
//  Created by daishi nakajima on 2016/02/22.
//  Copyright © 2016年 daishi nakajima. All rights reserved.
//

import Foundation
import GoogleMaps

class MapMarker: NSObject {
    enum LibraryMarker {
        case Google(GMSMarker)
        case MapKit(DefaultAnnotation)
        
    }
    let library: LibraryMarker
    
    init(library: LibraryMarker) {
        self.library = library
        super.init()
    }
    
    var title: String? {
        set {
            switch library {
            case .Google(let a):
                a.title = newValue
            case .MapKit(let a):
                a.title = newValue
            }
        }
        get {
            switch library {
            case .Google(let a):
                return a.title
            case .MapKit(let a):
                return a.title
            }
        }
    }
    
    var snippet: String? {
        set {
            switch library {
            case .Google(let a):
                a.snippet = newValue
            case .MapKit(let a):
                a.subtitle = newValue
            }
        }
        get {
            switch library {
            case .Google(let a):
                return a.snippet
            case .MapKit(let a):
                return a.subtitle
            }
        }
    }
    
    var mapView: MapView? {
        didSet {
            switch (library, mapView?.library, oldValue?.library) {
            case let (.Google(marker), .Some(.Google(map)), _):
                // add marker for google map
                marker.map = map
            case let (.MapKit(marker), .Some(.MapKit(map)), _):
                // add marker for map kit
                map.addAnnotation(marker)
            case let (.Google(marker), .None, _):
                // remove marker for google map
                marker.map = nil
            case let (.MapKit(marker), .None, .Some(.MapKit(oldMap))):
                // remove marker for map kit
                oldMap.removeAnnotation(marker)
            default:
                break
            }
        }
    }
    
    var userData: AnyObject? {
        set {
            switch library {
            case .Google(let a):
                a.userData = newValue
            case .MapKit(let a):
                a.userData = newValue
            }
        }
        get {
            switch library {
            case .Google(let a):
                return a.userData
            case .MapKit(let a):
                return a.userData
            }
        }
    }
    
    var icon: UIImage? {
        set {
            switch library {
            case .Google(let a):
                a.icon = newValue
            case .MapKit(let a):
                a.image = newValue
            }
        }
        get {
            switch library {
            case .Google(let a):
                return a.icon
            case .MapKit(let a):
                return a.image
            }
        }
    }
    
}