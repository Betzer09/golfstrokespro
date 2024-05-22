//
//  GolfTrackProApp.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/19/24.
//

import SwiftUI
import SwiftData

@main
struct GolfTrackProApp: App {
    @State private var isLoading = true

    var body: some Scene {
        WindowGroup {
            if isLoading {
                LandingView()
            } else {
                MainTabView()
            }
        }
        .modelContainer(for: [Swing.self, Score.self, Club.self]) { result in
            switch result {
            case .success:
                print("Persistence layer has been configured.")
                DispatchQueue.main.async {
                    isLoading = false
                }
            case .failure(let error):
                print("Failed to configure persistence layer. Error: \(error)")
            }
        }
    }
}

