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

    // register app delegate for Firebase setup
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

