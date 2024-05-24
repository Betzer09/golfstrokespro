//
//  Game.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/23/24.
//

import Foundation
import SwiftData

@Model
class Game: ObservableObject {

    @Relationship(deleteRule: .cascade) var scores: [Score]
    let id = UUID()
    var completedAt: Date?
    let createdAt: Date = Date()

    init(completedAt: Date? = nil, scores: [Score] = []) {
        self.completedAt = completedAt
        self.scores = scores
    }
}
