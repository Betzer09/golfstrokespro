//
//  Club.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/22/24.
//

import Foundation
import SwiftData

@Model
class Club: Codable {
    let id: UUID
    let type: ClubType

    init(id: UUID = UUID(), type: ClubType) {
        self.id = id
        self.type = type
    }

    // Custom initializer for decoding
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        type = try container.decode(ClubType.self, forKey: .type)
    }

    // Custom method for encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
    }

    // Coding keys
    enum CodingKeys: String, CodingKey {
        case id
        case type
    }
}

//// Need to add the following commented values as club selections
//enum ClubType: String, CaseIterable, Identifiable, Codable {
//    case wood // 1-10 selection
//    case iron // 1-9, P selection
//    case hybrid // 1-10 selection
//    case wedge // ptiching, gap, sand lob 46-72
//    case putter
//
//    var id: String {rawValue}
//}

// Need to add the following commented values as club selections
enum ClubType: String, CaseIterable, Identifiable, Codable {
    case dr
    case threeWood = "3w"
    case twoHybrid = "2Hy"
    case sixIron = "6i"
    case sevenIron = "7i"
    case eightIron = "8i"
    case nineIron = "9i"
    case pitchingWege = "Pw"
    case sandWedge = "Sw"
    case wedgeFiftyTwo = "W-52"
    case wedgeFiftySix = "W-56"
    case wedgeSixty = "W-60"
    case putter

    var id: String {rawValue}
}

/// A static list of currenlty available mock clubs
let allClubs: [Club] = ClubType.allCases.map { Club(type: $0) }

