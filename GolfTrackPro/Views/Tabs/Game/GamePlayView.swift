//
//  GamePlayView.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/19/24.
//
import SwiftUI
import SwiftData

struct GamePlayView: View {
    @Environment(\.modelContext) var modelContext
    @Query(filter: #Predicate<Game> { game in
        game.completedAt == nil
    }, sort: \Game.createdAt, order: .reverse) private var queryiedGames: [Game]
    private var numberOfHoles: Int {
        return queryiedGames.first?.gameplay == .eighteenHoles ? 18 : 9
    }
    @State private var showEndGameAlert = false

    var body: some View {
        NavigationView {
            VStack {
                if let game = queryiedGames.first {
                    if let course = game.course {
                        Text("Course: \(course)")
                            .font(.headline)
                    }
                    let gameplay = game.gameplay ?? .eighteenHoles
                    Text("Gameplay: \(gameplay.rawValue)")
                        .font(.subheadline)
                        .padding(.bottom)

                    let scores = game.scores
                    List(scores.sorted(by: { $0.hole < $1.hole }), id: \.self) { score in
                        NavigationLink(destination: HoleDetailView(hole: score.hole, score: score, isEditable: true)) {
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
            print("No ongoing games. Please start a new game.")
        }
    }

    private func endGame() {
        if let game = queryiedGames.first {
            game.completedAt = Date()
        }
        startGame()
    }

    private func startGame() {
        // This method is not needed anymore as games are created in the OverviewView.
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
    GamePlayView()
}
