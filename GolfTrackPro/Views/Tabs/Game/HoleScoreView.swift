//
//  HoleScoreView.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/19/24.
//

import SwiftUI

struct HoleScoreView: View {
    let hole: Int
    @Binding var score: Score

    var body: some View {
        HStack {
            Text("Hole \(hole)")
            Spacer()
            LocationTrackerView(score: $score)
            ScoreAdjuster(hole: hole, score: $score)
        }
    }
}

#Preview {
    HoleScoreView(hole: 0,
                  score: .constant(PreviewConstants.score))
}
