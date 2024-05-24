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
    @Query(filter: #Predicate<Game> { game in
        game.completedAt == nil
    }, sort: \Game.createdAt, order: .reverse) private var queryiedGames: [Game]
    private var numberOfHoles: Int = 18
    @State private var showEndGameAlert = false

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
            .navigationBarItems(trailing: Button(action: {
                showEndGameAlert = true
            }) {
                Text("End Game")
                    .foregroundColor(.red)
            })
            .alert(isPresented: $showEndGameAlert) {
                Alert(
                    title: Text("End Game"),
                    message: Text("Are you sure you want to end the game?"),
                    primaryButton: .destructive(Text("End Game")) {
                        endGame()
                    },
                    secondaryButton: .cancel()
                )
            }
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
        if let game = queryiedGames.first {
            game.completedAt = Date()
        }
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
