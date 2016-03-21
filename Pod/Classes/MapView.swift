//
//  MapView.swift
//  beer-app-ios
//
//  Created by daishi nakajima on 2016/02/22.
//  Copyright © 2016年 daishi nakajima. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps

/**
 * Wrapper for GMSMapView & MKMapView
 */
class MapView: UIView, GMSMapViewDelegate, MKMapViewDelegate {
    /// any map view
    enum LibraryMapView {
        case Google(GMSMapView)
        case MapKit(MKMapView)
        func mapView<U>(f: (UIView) -> (U)) -> U {
            switch self {
            case .Google(let v):
                return f(v)
            case .MapKit(let v):
                return f(v)
            }
        }
    }
    // libray map view instance
    let library: LibraryMapView
//    // select instance from xib
//    @IBInspectable var useLibraryType: String = ""
    
    weak var delegate: MapViewDelegate? {
        didSet {
            switch library {
            case .Google(let v):
                v.delegate = self
            case .MapKit(let v):
                v.delegate = self
            }
        }
    }
    
    let markerReuseId = "mapkit_marker"
    
    ///init with library you want to use
    init(library: LibraryMapView) {
        self.library = library
        super.init(frame: CGRectZero)
        self.addSubview(library.mapView({$0}))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    required init?(coder aDecoder: NSCoder) {
//        switch useLibraryType {
//        case "Google":
//            library = LibraryMapView.Google(GMSMapView())
//        default:
//            library = LibraryMapView.MapKit(MKMapView())
//        }
//        super.init(coder: aDecoder)
//        self.addSubview(library.mapView({$0}))
//    }
    
    override func layoutSubviews() {
        library.mapView({v in v.frame = self.bounds})
    }
    
    /// show user location
    var myLocationEnabled = false {
        didSet {
            switch library {
            case .Google(let v):
                v.myLocationEnabled = myLocationEnabled
            case .MapKit(let v):
                v.showsUserLocation = myLocationEnabled
            }
        }
    }

    var myLocationButtonEnabled = false {
        didSet {
            switch library {
            case .Google(let v):
                v.settings.myLocationButton = myLocationButtonEnabled
            case .MapKit(_):
                //TODO: impl
                break
            }
        }
    }
    
    func setCenterCoordinate(coordinate: CLLocationCoordinate2D, zoom: Float) {
        switch library {
        case .Google(let v):
            v.camera = GMSCameraPosition(target: coordinate, zoom: zoom, bearing: 0, viewingAngle: 0)
        case .MapKit(let v):
            v.setCenterCoordinate(coordinate, zoomLevel: Int(zoom), animated: false)
        }
    }
    
    func nearLeftCoordinate() -> CLLocationCoordinate2D {
        switch library {
        case .Google(let v):
            return v.projection.visibleRegion().nearLeft
        case .MapKit(let v):
            let point = CGPointMake(v.bounds.origin.x, v.bounds.origin.y);
            return v.convertPoint(point, toCoordinateFromView: v)
        }
    }
    
    func nearRightCoordinate() -> CLLocationCoordinate2D {
        switch library {
        case .Google(let v):
            return v.projection.visibleRegion().nearRight
        case .MapKit(let v):
            let point = CGPointMake(v.bounds.origin.x + v.bounds.width, v.bounds.origin.y);
            return v.convertPoint(point, toCoordinateFromView: v)
        }
    }
    
    func targetCoordinate() -> CLLocationCoordinate2D {
        switch library {
        case .Google(let v):
            return v.camera.target
        case .MapKit(let v):
            return v.centerCoordinate
        }
   
    }
    
    //Google Map Delegates
    func mapView(mapView: GMSMapView, didChangeCameraPosition position: GMSCameraPosition) {
        self.delegate?.mapViewWillMove(self)
    }
    func mapView(mapView: GMSMapView, idleAtCameraPosition position: GMSCameraPosition) {
        self.delegate?.mapViewIdlePosition(self)
    }
    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) {
        // it maybe be trouble because another instance
        self.delegate?.mapView(self, didTapInfoWindowOfMarker: MapMarker(library: MapMarker.LibraryMarker.Google(marker)))
    }
    //MaoKit Delegates
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        self.delegate?.mapViewWillMove(self)
    }
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.delegate?.mapViewIdlePosition(self)
    }
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? DefaultAnnotation {
            self.delegate?.mapView(self, didTapInfoWindowOfMarker: MapMarker(library: MapMarker.LibraryMarker.MapKit(annotation)))
        } else {
            NSLog("[MapView] Unknown annotation is tapped")
        }
    }
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? DefaultAnnotation {
            var view = mapView.dequeueReusableAnnotationViewWithIdentifier(markerReuseId)
            if (view == nil) {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: markerReuseId)
            }
            
            view?.annotation = annotation
            view?.image = annotation.image
            view?.canShowCallout = true
            view?.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure)
            
            return view
        }
        return nil
    }
}
