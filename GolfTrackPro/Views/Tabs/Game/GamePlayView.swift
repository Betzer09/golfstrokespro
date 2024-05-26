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
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var previousHole: Score?
    @State private var isInitialized = false

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
                            HoleScoreView(hole: score.hole, score: score, onSwingAdded: {
                                lockPreviousHoleIfNeeded(score: score)
                            })
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
            .onAppear {
                if !isInitialized {
                    initializePreviousHole()
                    isInitialized = true
                }
            }
            .overlay(
                showToast ? AnyView(Toast(message: toastMessage)) : AnyView(EmptyView()),
                alignment: .top
            )
        }
    }

    private func initializePreviousHole() {
        if let game = queryiedGames.first {
            previousHole = game.scores.filter { !$0.swings.isEmpty }
                .max(by: { $0.swings.last?.timestamp ?? Date.distantPast < $1.swings.last?.timestamp ?? Date.distantPast })
        }
    }

    private func lockPreviousHoleIfNeeded(score: Score) {
        if let previousHole = previousHole, previousHole.hole != score.hole {
            previousHole.isLocked = true
            showToast(message: "Hole \(previousHole.hole) was locked. Swipe to unlock if needed.")
        }
        previousHole = score
    }

    private func showToast(message: String) {
        toastMessage = message
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            withAnimation {
                showToast = false
            }
        }
    }

    private func endGame() {
        if let game = queryiedGames.first {
            game.completedAt = Date()
        }
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
