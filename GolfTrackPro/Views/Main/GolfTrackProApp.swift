//
//  GolfTrackProApp.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/19/24.
//

import SwiftUI
import SwiftData
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct GolfTrackProApp: App {
    @State private var isLoading = true

    // Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            if isLoading {
                LandingView()
            } else {
                MainTabView()
            }
        }
        .modelContainer(for: [Game.self, Swing.self, Score.self, Club.self]) { result in
            switch result {
            case .success(let container):
                print("Persistence layer has been configured.")
                DispatchQueue.global().async {
//                    generateTestGames(context: container)
                    DispatchQueue.main.async {
                        isLoading = false
                    }
                }
            case .failure(let error):
                print("Failed to configure persistence layer. Error: \(error)")
            }
        }
    }

    private func generateTestGames(context: ModelContainer) {
        let modelContext = ModelContext(context)

        for _ in 0..<100 {
            let number: Double = Double.random(in: -10000.0...10000.0)
            let game = Game(completedAt: Date().addingTimeInterval(number), course: "Test Course", gameplay: .eighteenHoles)
            let scores = (1...18).map { hole in
                let score = Score(game: game, hole: hole)
                let swings = (1...20).map { _ in
                    Swing(score: score, club: allClubs.randomElement() ?? Club(type: .dr), distance: Double.random(in: 100...300))
                }
                score.swings = swings
                return score
            }
            game.scores = scores
            modelContext.insert(game)
        }

        do {
            try modelContext.save()
        } catch {
            print("Failed to save test games: \(error.localizedDescription)")
        }
    }
}
