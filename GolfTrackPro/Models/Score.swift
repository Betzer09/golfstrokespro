//
//  Score.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/19/24.
//

import Foundation

struct Score {
    var swings: [Swing]
    let hole: Int
}

struct Swing: Identifiable {
    let id = UUID()
    let timestamp: Date
    var club: Club?

    init(timestamp: Date = Date(), club: Club? = nil) {
        self.timestamp = timestamp
        self.club = club
    }
}

struct Club: Identifiable, Hashable {
    let id = UUID()
    let type: ClubType
}

// Need to add the following commented values as club selections
enum ClubType: String, CaseIterable, Identifiable {
    case wood // 1-10 selection
    case iron // 1-9, P selection
    case hybrid // 1-10 selection
    case wedge // ptiching, gap, sand lob 46-72
    case putter

    var id: String {rawValue}
}

/// A static list of currenlty available mock clubs
let allClubs: [Club] = ClubType.allCases.map { Club(type: $0) }

