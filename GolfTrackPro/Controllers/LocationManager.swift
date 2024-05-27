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

    private let userDefaults = UserDefaults.standard
    private let cacheKey = "cachedGolfCourses"
    private let locationKey = "lastKnownLocation"

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

        // Check for significant location change
        if let lastKnownLocation = getLastKnownLocation(),
           CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude).distance(from: lastKnownLocation) < 1609 {
            // Return cached data if within 1 mile
            if let cachedGolfCourses = getCachedGolfCourses() {
                self.nearbyGolfCourses = cachedGolfCourses
                completion(cachedGolfCourses)
                return
            }
        }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Golf Course"
        let threeMiles: Double = 1609 * 3
        request.region = MKCoordinateRegion(center: userLocation, latitudinalMeters: threeMiles, longitudinalMeters: threeMiles)

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let error = error {
                print("***Error searching for golf courses: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let response = response else {
                print("***No golf courses found")
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
                self.cacheGolfCourses(filteredMapItems)
                self.cacheLastKnownLocation(CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude))
                completion(filteredMapItems)
            }
        }
    }

    private func cacheGolfCourses(_ golfCourses: [MKMapItem]) {
        do {
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: golfCourses, requiringSecureCoding: false)
            userDefaults.set(encodedData, forKey: cacheKey)
        } catch {
            print("***Failed to cache golf courses: \(error.localizedDescription)")
        }
    }

    private func getCachedGolfCourses() -> [MKMapItem]? {
        guard let data = userDefaults.data(forKey: cacheKey) else { return nil }
        do {
            if let golfCourses = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, MKMapItem.self], from: data) as? [MKMapItem] {
                return golfCourses
            }
        } catch {
            print("***Failed to retrieve cached golf courses: \(error.localizedDescription)")
        }
        return nil
    }

    private func cacheLastKnownLocation(_ location: CLLocation) {
        do {
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: location, requiringSecureCoding: false)
            userDefaults.set(encodedData, forKey: locationKey)
        } catch {
            print("***Failed to cache last known location: \(error.localizedDescription)")
        }
    }

    private func getLastKnownLocation() -> CLLocation? {
        guard let data = userDefaults.data(forKey: locationKey) else { return nil }
        do {
            if let location = try NSKeyedUnarchiver.unarchivedObject(ofClass: CLLocation.self, from: data) {
                return location
            }
        } catch {
            print("***Failed to retrieve cached last known location: \(error.localizedDescription)")
        }
        return nil
    }
}
