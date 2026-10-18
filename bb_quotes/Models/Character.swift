//
//  Character.swift
//  bb_quotes
//
//  Created by Lucca Filizzola on 11/08/26.
//

import Foundation

// MARK: - Character
struct Char: Codable {
    let name, birthday: String
    let occupations: [String]
    let images: [URL]
    let aliases: [String]
    let status: String
    let portrayedBy: String

    enum CodingKeys: String, CodingKey {
        case name, birthday, occupations, images
        case aliases, status
        case portrayedBy = "portrayed_by"
    }

    var isDead: Bool { status == "Dead" }
}
