//
//  MockGameGenerator.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/26/24.
//


import SwiftUI
import SwiftData

func generateTestGames(modelContext: ModelContext) {
    for index in 0..<1000 {
        let game = Game(course: "Test Course \(index)", gameplay: .eighteenHoles)
        let scores = (1...18).map { hole in
            let score = Score(game: game, hole: hole)
            let swings = (1...20).map { _ in
                Swing(score: score, distance: Double.random(in: 0...300))
            }
            score.swings = swings
            return score
        }
        game.scores = scores
        modelContext.insert(game)
    }
}

