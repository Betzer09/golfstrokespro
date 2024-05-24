//
//  CompletedGameView.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/23/24.
//

import SwiftUI

import SwiftUI

struct CompletedGameDetailView: View {
    let game: Game

    var body: some View {
        VStack {
            List(game.scores.sorted(by: { $0.hole < $1.hole }), id: \.self) { score in
                NavigationLink(destination: DetailView(hole: score.hole, 
                                                       score: score, 
                                                       isEditable: false)) {
                    HStack {
                        Text("Hole \(score.hole)")
                        Spacer()
                        Text("Score: \(score.swings.count)")
                    }
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
        .navigationTitle("Scorecard")
    }

    private func totalScore() -> Int {
        return game.scores.reduce(0) { $0 + $1.swings.count }
    }
}

#Preview {
    CompletedGameDetailView(game: Game())
}


#Preview {
    CompletedGameDetailView(game: Game())
}


