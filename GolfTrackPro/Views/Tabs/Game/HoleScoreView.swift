//
//  HoleScoreView.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/19/24.
//

import SwiftUI

struct HoleScoreView: View {
    let hole: Int
    @Bindable var score: Score

    var body: some View {
        HStack {
            Text("Hole \(hole)")
            Spacer()
            HoleLocationTrackingView(score: score)
            HoleScoreAdjuster(hole: hole, score: score)
        }
    }
}

#Preview {
    HoleScoreView(hole: 0,
                  score: PreviewConstants.score)
}
