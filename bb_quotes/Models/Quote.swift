//
//  Quote.swift
//  bb_quotes
//
//  Created by Lucca Filizzola on 11/08/26.
//

import Foundation


struct Quote: Codable {
    let quote: String
    let character: String
    let episode: Int

    /// The API encodes episodes as `SEE` (e.g. 103), shown here as "S1E03".
    var episodeCode: String {
        "S\(episode / 100)E" + String(format: "%02d", episode % 100)
    }
}
