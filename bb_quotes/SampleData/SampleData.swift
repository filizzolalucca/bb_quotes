//
//  SampleData.swift
//  bb_quotes
//
//  Created by Lucca Filizzola on 17/10/26.
//

import Foundation

/// The bundled sample JSON, decoded for SwiftUI previews.
enum SampleData {
    static let quote: Quote = decode("samplequote")
    static let character: Char = decode("samplecharacter")
    static let death: Death = decode("sampledeath")

    private static func decode<T: Decodable>(_ file: String) -> T {
        guard let url = Bundle.main.url(forResource: file, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let value = try? JSONDecoder().decode(T.self, from: data)
        else {
            fatalError("Couldn't decode \(file).json")
        }
        return value
    }
}
