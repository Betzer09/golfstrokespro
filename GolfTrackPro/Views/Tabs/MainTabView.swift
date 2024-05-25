//
//  MainTabView.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/22/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            GamePlayView()
                .tabItem {
                    Label("Game", systemImage: "figure.golf")
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
