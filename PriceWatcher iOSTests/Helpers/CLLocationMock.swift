//
//  CLLocationMock.swift
//  PriceWatcher-iOS
//
//  Created by Fahim Jatmiko on 19/03/22.
//

import Foundation
import CoreLocation

protocol LocationManager {
    // CLLocationManager Properties
    var location: CLLocation? { get }
    var delegate: CLLocationManagerDelegate? { get set }
    var distanceFilter: CLLocationDistance { get set }
    var pausesLocationUpdatesAutomatically: Bool { get set }
    var allowsBackgroundLocationUpdates: Bool { get set }

    // CLLocationManager Methods
    func requestWhenInUseAuthorization()
    func startUpdatingLocation()
    func stopUpdatingLocation()
    
    // Wrappers for CLLocationManager class functions.
    var authorizationStatus: CLAuthorizationStatus { get }
//    func getAuthorizationStatus() -> CLAuthorizationStatus
    func isLocationServicesEnabled() -> Bool
}

extension CLLocationManager: LocationManager {
//    func getAuthorizationStatus() -> CLAuthorizationStatus {
//        return CLLocationManager.authorizationStatus()
//    }

    func isLocationServicesEnabled() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
}

class MockLocationManager: LocationManager {
    var location: CLLocation? = CLLocation(
        latitude: 37.3317,
        longitude: -122.0325086
    )

    var delegate: CLLocationManagerDelegate?
    var distanceFilter: CLLocationDistance = 10
    var pausesLocationUpdatesAutomatically = false
    var allowsBackgroundLocationUpdates = true

    func requestWhenInUseAuthorization() { }
    func startUpdatingLocation() { }
    func stopUpdatingLocation() { }
    
    var authorizationStatus: CLAuthorizationStatus {
        return .authorizedWhenInUse
    }
    
    func isLocationServicesEnabled() -> Bool {
        true
    }
}
