//
//  LocationTracker.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/21/24.
//

import SwiftUI
import CoreLocation

struct LocationTrackerView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var isTracking = false
    @State private var enableLocationAlert = false
    @State private var showClubPicker = false
    @State private var selectedClub: Club? = nil

    @Bindable var score: Score

    var body: some View {
        VStack {
            Button(action: {
                handleLocationButtonTapped()
            }) {
                Image(systemName: isTracking ? "stop.circle.fill" : "location.fill.viewfinder")
                    .foregroundColor(.blue)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.trailing, 8)
            .alert(isPresented: $enableLocationAlert) {
                Alert(
                    title: Text("Location Permission Required"),
                    message: Text("Please enable location permissions in settings to use this feature."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .sheet(isPresented: $showClubPicker) {
                ClubPicker(selectedClub: $selectedClub, onClubSelected: {
                    startTracking()
                    showClubPicker = false
                })
            }

            if isTracking, let distance = locationManager.currentDistance {
                Text("\(Int(distance)) yds")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }

    private func handleLocationButtonTapped() {
        if isTracking {
            stopTracking()
        } else {
            let authorizationStatus = locationManager.locationManager.authorizationStatus
            if authorizationStatus == .notDetermined {
                locationManager.requestLocationPermissions()
            } else if locationManager.isLocationMonitoringEnabled {
                showClubPicker = true
            } else {
                enableLocationAlert = true
            }
        }
    }

    private func startTracking() {
        guard let _ = selectedClub else { return }
        locationManager.startTracking()
        isTracking = true
        print("Started tracking")
    }

    private func stopTracking() {
        locationManager.stopTracking()
        if let distance = locationManager.currentDistance {
            let newSwing = Swing(score: score, club: selectedClub, distance: distance)
            score.swings.append(newSwing)
            print("Stopped tracking. Distance: \(distance) yards. New swing added.")
        }
        isTracking = false
    }
}


#Preview {
    LocationTrackerView(score: PreviewConstants.score)
}
