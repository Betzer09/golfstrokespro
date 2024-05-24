//
//  LocationManager.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/21/24.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var startLocation: CLLocation?
    @Published var currentDistance: Double?
    @Published var isLocationMonitoringEnabled: Bool = false

    override init() {
        super.init()
        locationManager.delegate = self
        updateLocationMonitoringStatus()
    }

    func requestLocationPermissions() {
        locationManager.requestWhenInUseAuthorization()
    }

    func startTracking() {
        locationManager.startUpdatingLocation()
        startLocation = nil
        currentDistance = nil
    }

    func stopTracking() {
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        if startLocation == nil {
            startLocation = newLocation
        } else if let startLocation = startLocation {
            let distance = newLocation.distance(from: startLocation) * 1.09361 // Convert meters to yards
            currentDistance = distance
        }
    }

    // Handle changes in authorization status
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        updateLocationMonitoringStatus()
    }

    private func updateLocationMonitoringStatus() {
        let status = locationManager.authorizationStatus
        isLocationMonitoringEnabled = (status == .authorizedWhenInUse || status == .authorizedAlways)
    }
}
