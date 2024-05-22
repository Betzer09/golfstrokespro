//
//  Swing.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/22/24.
//

import Foundation
import SwiftData

@Model
class Swing {
    let id = UUID()
    let timestamp: Date
    var club: Club?
    var distance: Double? // Distance in yards


    init(timestamp: Date = Date(), club: Club? = nil, distance: Double? = nil) {
        self.timestamp = timestamp
        self.club = club
        self.distance = distance
    }
}
