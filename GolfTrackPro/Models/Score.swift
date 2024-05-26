//
//  Score.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/19/24.
//

import Foundation
import SwiftData

@Model
class Score: ObservableObject, Codable {
    @Relationship(deleteRule: .cascade) var swings: [Swing] = []
    let game: Game
    let hole: Int

    init(game: Game, hole: Int) {
        self.hole = hole
        self.game = game
    }

    // Custom initializer for decoding
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        swings = try container.decode([Swing].self, forKey: .swings)
        game = try container.decode(Game.self, forKey: .game)
        hole = try container.decode(Int.self, forKey: .hole)
    }

    // Custom method for encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(swings, forKey: .swings)
        try container.encode(game, forKey: .game)
        try container.encode(hole, forKey: .hole)
    }

    // Coding keys
    enum CodingKeys: String, CodingKey {
        case swings
        case game
        case hole
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
