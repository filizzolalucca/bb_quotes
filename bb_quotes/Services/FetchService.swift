//
//  FetchService.swift
//  bb_quotes
//
//  Created by Lucca Filizzola on 17/10/26.
//

import Foundation

struct FetchService {
    enum FetchError: LocalizedError {
        case badResponse

        var errorDescription: String? {
            "Couldn't reach the server. Please try again."
        }
    }

    private let baseURL = URL(string: "https://breaking-bad-api-six.vercel.app/api")!

    func fetchQuote(from show: Show) async throws -> Quote {
        let url = baseURL
            .appending(path: "quotes/random")
            .appending(queryItems: [URLQueryItem(name: "production", value: show.rawValue)])
        return try await fetch(Quote.self, from: url)
    }

    /// Returns `nil` when the API has no profile for that character (it answers with a 404).
    func fetchCharacter(named name: String) async throws -> Char? {
        let url = baseURL
            .appending(path: "characters")
            .appending(queryItems: [URLQueryItem(name: "name", value: name)])
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse else { throw FetchError.badResponse }
        if response.statusCode == 404 { return nil }
        guard response.statusCode == 200 else { throw FetchError.badResponse }

        return try JSONDecoder().decode([Char].self, from: data).first
    }

    /// Returns `nil` when the character's death isn't in the API.
    func fetchDeath(for character: String) async throws -> Death? {
        let deaths = try await fetch([Death].self, from: baseURL.appending(path: "deaths"))
        return deaths.first { $0.character == character }
    }

    private func fetch<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
}
