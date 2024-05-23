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
    let hole: Int

    init(hole: Int) {
        self.hole = hole
    }
}

class PreviewConstants {
    static let score = Score(hole: 1)
    static let swingData = [
        Swing(score: score, timestamp: Date()),
        Swing(score: score, timestamp: Date().addingTimeInterval(300)),
        Swing(score: score, timestamp: Date().addingTimeInterval(600)),
    ]
}
