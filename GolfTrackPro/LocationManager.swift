//
//  LocationManager.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/21/24.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func requestLocationPermissions() {
        locationManager.requestWhenInUseAuthorization()
    }

    // Handle changes in authorization status
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("Location permissions not determined")
        case .restricted, .denied:
            print("Location permissions denied")
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location permissions granted")
        @unknown default:
            break
        }
    }
}
