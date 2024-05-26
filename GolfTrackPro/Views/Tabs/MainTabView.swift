//
//  MainTabView.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/22/24.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @Query(filter: #Predicate<Game> { game in
        game.completedAt == nil
    }, sort: \Game.createdAt, order: .reverse) private var queryiedGames: [Game]

    var body: some View {
        TabView {
            if queryiedGames.isEmpty {
                StartGameView()
                    .tabItem {
                        Label("Overview", systemImage: "house.fill")
                    }
            } else {
                GamePlayView()
                    .tabItem {
                        Label("Game", systemImage: "figure.golf")
                    }
            }

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.fill")
                }

            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.fill")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}

#Preview {
    MainTabView()
}
