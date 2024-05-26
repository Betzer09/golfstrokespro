//
//  ScoreAdjustor.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/21/24.
//

import SwiftUI

struct HoleScoreAdjuster: View {
    let hole: Int
    @Bindable var score: Score
    @Binding var showLockAlert: Bool

    var body: some View {
        HStack {
            Text("\(score.swings.count)")
                .frame(width: 40)
                .multilineTextAlignment(.center)

            Button(action: {
                if score.isLocked {
                    showLockAlert = true
                } else {
                    score.swings.append(Swing(score: score))
                    print("Increased score for hole \(hole) to \(score.swings.count)")
                }
            }) {
                Image(systemName: "plus.circle")
                    .foregroundColor(score.isLocked ? .gray : .green)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.leading, 8)
        }
    }
}


#Preview {
    HoleScoreAdjuster(hole: 8,
                      score: PreviewConstants.score,
                      showLockAlert: .constant(false))
}
