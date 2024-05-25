//
//  ScoreAdjustor.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/21/24.
//

import SwiftUI

struct ScoreAdjuster: View {
    let hole: Int
    @Bindable var score: Score

    var body: some View {
        HStack {
            Text("\(score.swings.count)")
                .frame(width: 40)
                .multilineTextAlignment(.center)

            Button(action: {
                score.swings.append(Swing(score: score))
                print("Increased score for hole \(hole) to \(score.swings.count)")
            }) {
                Image(systemName: "plus.circle")
                    .foregroundColor(.green)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.leading, 8)
        }
    }
}

#Preview {
    ScoreAdjuster(hole: 8,
                  score: PreviewConstants.score)
}
