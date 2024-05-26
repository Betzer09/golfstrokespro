//
//  OverviewView.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/25/24.
//

import SwiftUI

struct StartGameView: View {
    @Environment(\.modelContext) var modelContext
    @State private var selectedCourse: String = ""
    @State private var selectedGameplay: GameplayType = .eighteenHoles
    @State private var showGamePlayView = false

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
