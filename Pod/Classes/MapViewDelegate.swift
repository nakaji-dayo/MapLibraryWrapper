//
//  MapViewDelegate.swift
//  beer-app-ios
//
//  Created by daishi nakajima on 2016/02/22.
//  Copyright © 2016年 daishi nakajima. All rights reserved.
//

import Foundation

protocol MapViewDelegate: class {
    func mapViewWillMove(mapView: MapView)
    func mapViewIdlePosition(mapView: MapView)
    func mapView(mapView: MapView, didTapInfoWindowOfMarker marker: MapMarker)
}

extension MapViewDelegate {
    func mapViewWillMove(mapView: MapView) {}
    func mapViewIdlePosition(mapView: MapView) {}
    func mapView(mapView: MapView, didTapInfoWindowOfMarker marker: MapMarker) {}
}