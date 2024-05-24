//
//  Swing.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/22/24.
//

import Foundation
import SwiftData

@Model
class Swing: ObservableObject {
    let id = UUID()
    let timestamp: Date
    @Relationship(deleteRule: .cascade) var club: Club?
    /// Distance in yards
    var distance: Double?

    init(score: Score,
         timestamp: Date = Date(),
         club: Club? = nil,
         
         distance: Double? = nil) {
        self.timestamp = timestamp
        self.club = club
        self.distance = distance
    }
}
