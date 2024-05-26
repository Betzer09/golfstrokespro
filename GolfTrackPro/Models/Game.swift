//
//  Game.swift
//  GolfTrackPro
//
//  Created by Austin Betzer on 5/23/24.
//

import Foundation
import SwiftData

@Model
class Game: ObservableObject, Codable {

    @Relationship(deleteRule: .cascade) var scores: [Score]
    let id = UUID()
    var completedAt: Date?
    let createdAt: Date = Date()
    var course: String?
    var gameplay: GameplayType?

    init(completedAt: Date? = nil, scores: [Score] = [], course: String? = nil, gameplay: GameplayType? = .eighteenHoles) {
        self.completedAt = completedAt
        self.scores = scores
        self.course = course
        self.gameplay = gameplay
    }

    // Custom initializer for decoding
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        completedAt = try container.decodeIfPresent(Date.self, forKey: .completedAt)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        course = try container.decodeIfPresent(String.self, forKey: .course)
        gameplay = try container.decode(GameplayType.self, forKey: .gameplay)
        scores = try container.decode([Score].self, forKey: .scores)
    }

    // Custom method for encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(completedAt, forKey: .completedAt)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(course, forKey: .course)
        try container.encode(gameplay, forKey: .gameplay)
        try container.encode(scores, forKey: .scores)
    }

    // Coding keys
    enum CodingKeys: String, CodingKey {
        case id
        case completedAt
        case createdAt
        case course
        case gameplay
        case scores
    }
}


enum GameplayType: String, CaseIterable, Identifiable, Codable {
    case eighteenHoles = "18 Holes"
    case frontNine = "Front 9"
    case backNine = "Back 9"

    var id: String { self.rawValue }
}
