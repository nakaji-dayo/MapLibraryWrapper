//
//  MKMapView+ZoomLevel.swift
//  Pods
//
//  Created by daishi nakajima on 2016/03/21.
//
//

import Foundation

import MapKit

extension MKMapView {
    @nonobjc static let MERCATOR_OFFSET: Double = 268435456
    @nonobjc static let MERCATOR_RADIUS: Double = 85445659.44705395
    
    func setCenterCoordinate(centerCoordinate: CLLocationCoordinate2D, zoomLevel: Int, animated: Bool) {
        let validZoomLevel = min(zoomLevel, 28)
        self.coordinateRegionWithMapView(self, centerCoordinate: centerCoordinate, andZoomLevel: validZoomLevel)
        let span = self.coordinateSpanWithMapView(self, centerCoordinate: centerCoordinate, andZoomLevel: validZoomLevel)
        
        let region = MKCoordinateRegionMake(centerCoordinate, span)
        self.setRegion(region, animated: animated)
    }
    
    func coordinateRegionWithMapView(mapView: MKMapView, centerCoordinate: CLLocationCoordinate2D, andZoomLevel zoomLevel: Int) -> MKCoordinateRegion {
        var center_ = centerCoordinate
        center_.latitude = min(max(-90.0, centerCoordinate.latitude), 90.0)
        center_.longitude = fmod(centerCoordinate.longitude, 180.0)
        let centerPixelX = MKMapView.longitudeToPixelSpaceX(center_.longitude)
        let centerPixelY = MKMapView.latitudeToPixelSpaceY(center_.latitude)
        let zoomExponent = 20 - zoomLevel
        let zoomScale = pow(2, Double(zoomExponent))
        let mapSizeInPixels = mapView.bounds.size
        let scaledMapWidth = Double(mapSizeInPixels.width) * zoomScale
        let scaledMapHeight = Double(mapSizeInPixels.height) * zoomScale
        let topLeftPixelX = centerPixelX - (scaledMapWidth / 2)
        let minLng = MKMapView.pixelSpaceXToLongitude(topLeftPixelX)
        let maxLng = MKMapView.pixelSpaceXToLongitude(topLeftPixelX + scaledMapWidth)
        let longitudeDelta = maxLng - minLng
        var topPixelY = centerPixelY - (scaledMapHeight / 2)
        var bottomPixelY = centerPixelY + (scaledMapHeight / 2)
        var adjustedCenterPoint = false
        if topPixelY > MKMapView.MERCATOR_OFFSET * 2 {
            topPixelY = centerPixelY - scaledMapHeight
            bottomPixelY = MKMapView.MERCATOR_OFFSET * 2
            adjustedCenterPoint = true
        }
        let minLat = MKMapView.pixelSpaceYToLatitude(topPixelY)
        let maxLat = MKMapView.pixelSpaceYToLatitude(bottomPixelY)
        let latitudeDelta = -1 * (maxLat - minLat)
        let span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta)
        var region = MKCoordinateRegionMake(center_, span)
        if adjustedCenterPoint {
            region.center.latitude = MKMapView.pixelSpaceYToLatitude(((bottomPixelY + topPixelY) / 2.0))
        }
        return region
    }
    
    func zoomLevel() -> Int {
        let region = self.region
        let centerPixelX = MKMapView.longitudeToPixelSpaceX(region.center.longitude)
        let topLeftPixelX = MKMapView.longitudeToPixelSpaceX(region.center.longitude - region.span.longitudeDelta / 2)
        let scaledMapWidth = (centerPixelX - topLeftPixelX) * 2
        let mapSizeInPixels = self.bounds.size
        let zoomScale = scaledMapWidth / Double(mapSizeInPixels.width)
        let zoomExponent = log(zoomScale) / log(2)
        let zoomLevel = 20 - zoomExponent
        return Int(zoomLevel)
    }
    
    private func coordinateSpanWithMapView(mapView: MKMapView, centerCoordinate: CLLocationCoordinate2D, andZoomLevel zoomLevel: Int) -> MKCoordinateSpan {
        let centerPixelX = MKMapView.longitudeToPixelSpaceX(centerCoordinate.longitude)
        let centerPixelY = MKMapView.latitudeToPixelSpaceY(centerCoordinate.latitude)
        let zoomExponent = 20 - zoomLevel
        let zoomScale = pow(2, Double(zoomExponent))
        let mapSizeInPixels = mapView.bounds.size
        let scaledMapWidth = Double(mapSizeInPixels.width) * zoomScale
        let scaledMapHeight = Double(mapSizeInPixels.height) * zoomScale
        let topLeftPixelX = centerPixelX - (scaledMapWidth / 2)
        let topLeftPixelY = centerPixelY - (scaledMapHeight / 2)
        let minLng = MKMapView.pixelSpaceXToLongitude(topLeftPixelX)
        let maxLng = MKMapView.pixelSpaceXToLongitude(topLeftPixelX + scaledMapWidth)
        let longitudeDelta = maxLng - minLng
        let minLat = MKMapView.pixelSpaceYToLatitude(topLeftPixelY)
        let maxLat = MKMapView.pixelSpaceYToLatitude(topLeftPixelY + scaledMapHeight)
        let latitudeDelta = -1 * (maxLat - minLat)
        let span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta)
        return span
    }
    
    class func longitudeToPixelSpaceX(longitude: Double) -> Double
    {
        return round(MERCATOR_OFFSET + MERCATOR_RADIUS * longitude * M_PI / 180.0);
    }
    
    class func latitudeToPixelSpaceY(latitude: Double) -> Double
    {
        if (latitude == 90.0) {
        return 0;
        } else if (latitude == -90.0) {
        return MERCATOR_OFFSET * 2;
        } else {
        return round(MERCATOR_OFFSET - MERCATOR_RADIUS * log((1 + sin(latitude * M_PI / 180.0)) / (1 - sin(latitude * M_PI / 180.0))) / 2.0);
        }
    }
    
    class func pixelSpaceXToLongitude(pixelX: Double) -> Double
    {
        return ((round(pixelX) - MERCATOR_OFFSET) / MERCATOR_RADIUS) * 180.0 / M_PI;
    }
    
    class func pixelSpaceYToLatitude(pixelY: Double) -> Double
    {
        return (M_PI / 2.0 - 2.0 * atan(exp((round(pixelY) - MERCATOR_OFFSET) / MERCATOR_RADIUS))) * 180.0 / M_PI;
    }
}
