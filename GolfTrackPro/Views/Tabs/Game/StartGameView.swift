//
//  OverviewView.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/25/24.
//

import SwiftUI
import MapKit

struct StartGameView: View {
    @Environment(\.modelContext) var modelContext
    @State private var selectedCourse: String = ""
    @State private var selectedGameplay: GameplayType = .eighteenHoles
    @State private var showGamePlayView = false
    @StateObject private var locationManager = LocationManager()
    @State private var isLoading = false

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter Course Name", text: $selectedCourse)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Picker("Select Gameplay", selection: $selectedGameplay) {
                    ForEach(GameplayType.allCases) { gameplay in
                        Text(gameplay.rawValue).tag(gameplay)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                if isLoading {
                    ProgressView("Searching for nearby golf courses...")
                        .padding()
                } else if locationManager.nearbyGolfCourses.isEmpty {
                    Text("No nearby golf courses found.")
                        .padding()
                } else {
                    List(locationManager.nearbyGolfCourses, id: \.self) { item in
                        Button(action: {
                            selectedCourse = item.name ?? ""
                        }) {
                            VStack(alignment: .leading) {
                                Text(item.name ?? "Unknown")
                                    .font(.headline)
                                Text(item.placemark.title ?? "")
                                    .font(.subheadline)
                            }
                        }
                    }
                }

                Button(action: startNewGame) {
                    Text("Start New Game")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
                .fullScreenCover(isPresented: $showGamePlayView) {
                    GamePlayView()
                }
            }
            .navigationTitle("Start New Game")
            .onAppear {
                locationManager.requestLocationPermissions()
                isLoading = true
                locationManager.searchForGolfCourses { _ in
                    isLoading = false
                }
            }
        }
    }

    private func startNewGame() {
        let game = Game(course: selectedCourse.isEmpty ? nil : selectedCourse, gameplay: selectedGameplay)
        let numberOfHoles = selectedGameplay == .eighteenHoles ? 18 : 9
        let startHole = selectedGameplay == .backNine ? 10 : 1
        let scores = (startHole..<(startHole + numberOfHoles)).map { Score(game: game, hole: $0) }
        game.scores = scores
        modelContext.insert(game)
        showGamePlayView = true
    }
}

#Preview {
    StartGameView()
}
