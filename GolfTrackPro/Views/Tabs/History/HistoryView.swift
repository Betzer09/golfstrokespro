//
//  HistoryView.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/22/24.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) var modelContext
    @Query(filter: #Predicate<Game> { game in
        game.completedAt != nil
    }, sort: \Game.createdAt, order: .reverse) private var completedGames: [Game]
    @State private var showDeleteAlert = false
    @State private var gameToDelete: Game?

    var body: some View {
        NavigationView {
            Group {
                if completedGames.isEmpty {
                    let noHistoryText = "It looks like you haven't completed any games yet. Start playing to see your game history here."
                    ContentUnavailableView("No Game History",
                                           systemImage: "golfclub", 
                                           description: Text(noHistoryText))

                } else {
                    CompletedGamesList(
                        completedGames: completedGames,
                        showDeleteAlert: $showDeleteAlert,
                        gameToDelete: $gameToDelete,
                        totalScore: totalScore,
                        dateFormatter: dateFormatter
                    )
                }
            }
            .navigationTitle("Game History")
        }
    }

    private func totalScore(for game: Game) -> Int {
        return game.scores.reduce(0) { $0 + $1.swings.count }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()


#Preview {
    HistoryView()
}
