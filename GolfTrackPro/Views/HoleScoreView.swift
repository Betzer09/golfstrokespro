//
//  HoleScoreView.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/19/24.
//

import SwiftUI

import SwiftUI

struct HoleScoreView: View {
    let hole: Int
    @Binding var swings: [Swing]
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        HStack {
            Text("Hole \(hole)")
            Spacer()
            
            Button(action: {
                locationManager.requestLocationPermissions()
            }) {
                Image(systemName: "location.fill.viewfinder")
                    .foregroundColor(.blue)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.trailing, 8)

            ScoreAdjuster(hole: hole, swings: $swings)
        }
    }
}


#Preview {
    HoleScoreView(hole: 0, swings: .constant([Swing]()))
}
