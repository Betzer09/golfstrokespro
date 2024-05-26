//
//  LocationManager.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/21/24.
//

import Foundation
import MapKit
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    @Published var startLocation: CLLocation?
    @Published var currentDistance: Double?
    @Published var isLocationMonitoringEnabled: Bool = false
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var nearbyGolfCourses: [MKMapItem] = []

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone
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
        userLocation = newLocation.coordinate
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        updateLocationMonitoringStatus()
    }

    private func updateLocationMonitoringStatus() {
        let status = locationManager.authorizationStatus
        isLocationMonitoringEnabled = (status == .authorizedWhenInUse || status == .authorizedAlways)
    }

    func searchForGolfCourses(completion: @escaping ([MKMapItem]?) -> Void) {
        guard let userLocation = locationManager.location?.coordinate else {
            completion(nil)
            return
        }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Golf Course"
        let threeMiles: Double = 1609 * 3
        request.region = MKCoordinateRegion(center: userLocation, latitudinalMeters: threeMiles, longitudinalMeters: threeMiles)

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let error = error {
                print("Error searching for golf courses: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let response = response else {
                print("No golf courses found")
                completion(nil)
                return
            }

            let filteredMapItems = response.mapItems.filter { item in
                if let location = item.placemark.location {
                    let distance = location.distance(from: CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude))
                    return distance <= threeMiles 
                }
                return false
            }

            DispatchQueue.main.async {
                self.nearbyGolfCourses = filteredMapItems
                completion(filteredMapItems)
            }
        }
    }
}
