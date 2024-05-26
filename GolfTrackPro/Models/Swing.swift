//
//  Swing.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/22/24.
//

import Foundation
import SwiftData

@Model
class Swing: ObservableObject, Codable {
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

    // Custom initializer for decoding
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
        club = try container.decodeIfPresent(Club.self, forKey: .club)
        distance = try container.decodeIfPresent(Double.self, forKey: .distance)
    }

    // Custom method for encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encodeIfPresent(club, forKey: .club)
        try container.encodeIfPresent(distance, forKey: .distance)
    }

    // Coding keys
    enum CodingKeys: String, CodingKey {
        case id
        case timestamp
        case club
        case distance
    }
}

