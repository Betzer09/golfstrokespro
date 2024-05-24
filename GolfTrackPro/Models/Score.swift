//
//  Score.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/19/24.
//

import Foundation
import SwiftData

@Model
class Score {
    @Relationship(deleteRule: .cascade) var swings: [Swing] = []
    let game: Game
    let hole: Int

    init(game: Game, hole: Int) {
        self.hole = hole
        self.game = game
    }
}

class PreviewConstants {
    static let game = Game()
    static let score = Score(game: game, hole: 1)
    static let swingData = [
        Swing(score: score, timestamp: Date()),
        Swing(score: score, timestamp: Date().addingTimeInterval(300)),
        Swing(score: score, timestamp: Date().addingTimeInterval(600)),
    ]
}
