//
//  HoleScoreView.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/19/24.
//

import SwiftUI

struct HoleScoreView: View {
    let hole: Int
    @Binding var swings: [Swing]

    var body: some View {
        HStack {
            Text("Hole \(hole)")
            Spacer()

            LocationTrackerView(swings: $swings)

            ScoreAdjuster(hole: hole, swings: $swings)
        }
    }
}




#Preview {
    HoleScoreView(hole: 0, swings: .constant([Swing]()))
}
