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
            List {
                ForEach(completedGames) { game in
                    NavigationLink(destination: CompletedGameDetailView(game: game)) {
                        VStack(alignment: .leading) {
                            Text("Game on \(game.createdAt, formatter: dateFormatter)")
                                .font(.headline)
                            Text("Score: \(totalScore(for: game))")
                                .font(.subheadline)
                        }
                    }
                }
                .onDelete { indexSet in
                    if let index = indexSet.first {
                        gameToDelete = completedGames[index]
                        showDeleteAlert = true
                    }
                }
            }
            .navigationTitle("Game History")
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Delete Game"),
                    message: Text("Are you sure you want to delete this game?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let game = gameToDelete {
                            modelContext.delete(game)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
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


#Preview {
    HistoryView()
}
