//
//  GolfRoundView.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/19/24.
//
import SwiftUI
import SwiftData

struct GolfRoundView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Game.createdAt, order: .forward) private var queryiedGames: [Game] = []
    @State private var numberOfHoles: Int = 18
    var body: some View {
        NavigationView {
            VStack {

                Picker("Number of Holes", selection: $numberOfHoles) {
                    Text("9 Holes").tag(9)
                    Text("18 Holes").tag(18)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                let scores = queryiedGames.first?.scores ?? []
                List(scores.sorted(by: { $0.hole < $1.hole }), id: \.self) { score in
                    NavigationLink(destination: DetailView(hole: score.hole,
                                                           score: score)) {
                        HoleScoreView(hole: score.hole,
                                      score: score)
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
            .onAppear(perform: loadScores)
        }
    }

    private func loadScores() {
        if queryiedGames.isEmpty {
            print("Creating a new game of scores.")
            startGame()
        }
    }

    private func startGame() {
        let game = Game()
        let scores = (1...$numberOfHoles.wrappedValue).map { Score(game:game, hole: $0) }
        game.scores = scores
        modelContext.insert(game)
    }

    func totalScore() -> Int {
        if let game = queryiedGames.first {
            return game.scores.reduce(0) { $0 + $1.swings.count }
        } else {
            return 0
        }
    }
}

#Preview {
    GolfRoundView()
}


#Preview {
    GolfRoundView()
}
