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
    @State private var isShowingLocationAlert = false

    @Bindable var score: Score

    var body: some View {
        VStack {
            Button(action: {
                if locationManager.isLocationMonitoringEnabled {
                    if isTracking {
                        locationManager.stopTracking()
                        if let distance = locationManager.currentDistance {
                            let newSwing = Swing(score: score, distance: distance)
                            score.swings.append(newSwing)
                            print("Stopped tracking. Distance: \(distance) yards. New swing added.")
                        }
                    } else {
                        locationManager.startTracking()
                        print("Started tracking")
                    }
                    isTracking.toggle()
                } else {
                    isShowingLocationAlert = true
                }
            }) {
                Image(systemName: isTracking ? "stop.circle.fill" : "location.fill.viewfinder")
                    .foregroundColor(.blue)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.trailing, 8)
            .alert(isPresented: $isShowingLocationAlert) {
                Alert(
                    title: Text("Location Permission Required"),
                    message: Text("Please enable location permissions in settings to use this feature."),
                    dismissButton: .default(Text("OK"))
                )
            }

            if isTracking, let distance = locationManager.currentDistance {
                Text("\(Int(distance)) yds")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .onAppear {
            locationManager.requestLocationPermissions()
        }
    }
}


#Preview {
    LocationTrackerView(score: PreviewConstants.score)
}
