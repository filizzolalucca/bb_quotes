//
//  Death.swift
//  bb_quotes
//
//  Created by Lucca Filizzola on 11/08/26.
//

import Foundation

struct Death: Codable {
    let character: String
    let image: URL
    let cause: String
    let details: String
    let lastWords: String

    enum CodingKeys: String, CodingKey {
        case character, image, cause, details
        case lastWords = "last_words"
    }
}
