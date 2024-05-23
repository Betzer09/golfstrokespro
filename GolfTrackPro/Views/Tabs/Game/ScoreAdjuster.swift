//
//  ScoreAdjustor.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/21/24.
//

import SwiftUI

struct ScoreAdjuster: View {
    let hole: Int
    var score: Score
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        HStack {
            Button(action: {
                if score.swings.count > 0, let lastSwing = score.swings.last {
                    modelContext.delete(lastSwing)
                    print("Decreased score for hole \(hole) to \(score.swings.count)")
                }
            }) {
                Image(systemName: "minus.circle")
                    .foregroundColor(.red)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.trailing, 8)

            Text("\(score.swings.count)")
                .frame(width: 40)
                .multilineTextAlignment(.center)

            Button(action: {
                let swing = Swing(score: score)
                modelContext.insert(swing)
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
