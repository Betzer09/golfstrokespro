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
    // TODO: Muliple games
    // I'm going to have to figure out some sort of flow if there are
    // more than one games returned.
    @Query(filter: #Predicate<Game> { game in
        game.completedAt == nil
    }, sort: \Game.createdAt, order: .reverse) private var queryiedGames: [Game]
    private var numberOfHoles: Int = 18

    var body: some View {
        NavigationView {
            VStack {
                let scores = queryiedGames.first?.scores ?? []
                List(scores.sorted(by: { $0.hole < $1.hole }), id: \.self) { score in
                    NavigationLink(destination: DetailView(hole: score.hole, score: score)) {
                        HoleScoreView(hole: score.hole, score: score)
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
            .navigationTitle("⛳️ GolfTrack Pro")
            .navigationBarItems(trailing: Button(action: endGame) {
                Text("End Game")
                    .foregroundColor(.red)
            })
            .onAppear(perform: loadScores)
        }
    }

    private func loadScores() {
        print("Number of persisted games: \(queryiedGames.count)")
        if queryiedGames.isEmpty {
            print("Creating a new game of scores.")
            startGame()
        }
    }

    private func startGame() {
        let game = Game()
        let scores = (1...numberOfHoles).map { Score(game: game, hole: $0) }
        game.scores = scores
        modelContext.insert(game)
    }

    private func endGame() {
        let game = queryiedGames.first
        game?.completedAt = Date()
        startGame()
    }

    private func totalScore() -> Int {
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
