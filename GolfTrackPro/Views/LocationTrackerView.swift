//
//  LocationTracker.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/21/24.
//

import SwiftUI

struct LocationTrackerView: View {
    @StateObject private var locationManager = LocationManager()
    @Binding var swings: [Swing]
    @State private var isTracking = false

    var body: some View {
        VStack {
            Button(action: {
                if isTracking {
                    locationManager.stopTracking()
                    if let distance = locationManager.currentDistance {
                        let newSwing = Swing(distance: distance)
                        swings.append(newSwing)
                        print("Stopped tracking. Distance: \(distance) yards. New swing added.")
                    }
                } else {
                    locationManager.startTracking()
                    print("Started tracking")
                }
                isTracking.toggle()
            }) {
                Image(systemName: isTracking ? "stop.circle.fill" : "location.fill.viewfinder")
                    .foregroundColor(.blue)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.trailing, 8)

            if isTracking, let distance = locationManager.currentDistance {
                Text("\(Int(distance)) yds")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}


#Preview {
    LocationTrackerView(swings: .constant([Swing()]))
}
