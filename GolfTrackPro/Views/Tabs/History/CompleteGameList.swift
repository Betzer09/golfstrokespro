//
//  CompleteGameList.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/24/24.
//

import SwiftUI

struct CompletedGamesList: View {
    let completedGames: [Game]
    @Binding var showDeleteAlert: Bool
    @Binding var gameToDelete: Game?
    let totalScore: (Game) -> Int
    let dateFormatter: DateFormatter
    @Environment(\.modelContext) var modelContext

    var body: some View {
        List {
            ForEach(completedGames) { game in
                NavigationLink(destination: CompletedGameDetailView(game: game)) {
                    VStack(alignment: .leading) {
                        Text("Game on \(game.createdAt, formatter: dateFormatter)")
                            .font(.headline)
                        Text("Score: \(totalScore(game))")
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
