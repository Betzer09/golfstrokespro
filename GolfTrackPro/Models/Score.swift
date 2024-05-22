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
    var swings: [Swing]
    let hole: Int

    init(swings: [Swing], hole: Int) {
        self.swings = swings
        self.hole = hole
    }
}
