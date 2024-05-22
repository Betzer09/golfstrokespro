//
//  GolfRoundView.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/19/24.
//

import SwiftUI

struct GolfRoundView: View {
    @State private var scores: [Score] = (1...18).map { Score(swings: [], hole: $0) }

    var body: some View {
        NavigationView {
            VStack {
                List(0..<18, id: \.self) { index in
                    NavigationLink(destination: DetailView(hole: scores[index].hole,
                                                           swings: $scores[index].swings)) {
                        HoleScoreView(hole: scores[index].hole,
                                      swings: $scores[index].swings)
                    }
                }

                HStack {
                    Text("Total Score")
                    Spacer()
                    Text("\(totalScore())") 
                        .bold()
                }
                .padding()
            }
        }
    }

    func totalScore() -> Int {
        scores.reduce(0) { $0 + $1.swings.count }
    }
}

#Preview {
    GolfRoundView()
}
