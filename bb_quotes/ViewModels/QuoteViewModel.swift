//
//  QuoteViewModel.swift
//  bb_quotes
//
//  Created by Lucca Filizzola on 17/10/26.
//

import Foundation
import Observation

@Observable
final class QuoteViewModel {
    enum Status {
        case notStarted
        case fetching
        case success
        case failed(Error)
    }

    private(set) var status: Status = .notStarted
    private(set) var quote: Quote?
    private(set) var character: Char?
    private(set) var death: Death?

    var isFetching: Bool {
        if case .fetching = status { true } else { false }
    }

    private let fetcher = FetchService()

    func getData(for show: Show) async {
        status = .fetching

        do {
            let quote = try await fetcher.fetchQuote(from: show)
            let character = try await fetcher.fetchCharacter(named: quote.character)

            var death: Death?
            if character?.isDead == true {
                death = try await fetcher.fetchDeath(for: quote.character)
            }

            self.quote = quote
            self.character = character
            self.death = death
            status = .success
        } catch {
            status = .failed(error)
        }
    }
}
