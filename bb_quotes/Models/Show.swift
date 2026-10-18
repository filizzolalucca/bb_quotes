//
//  Show.swift
//  bb_quotes
//
//  Created by Lucca Filizzola on 17/10/26.
//

import SwiftUI

enum Show: String, CaseIterable, Identifiable {
    case breakingBad = "Breaking Bad"
    case betterCallSaul = "Better Call Saul"

    var id: Self { self }

    var title: String { rawValue }

    var symbol: String {
        switch self {
        case .breakingBad: "tortoise"
        case .betterCallSaul: "briefcase"
        }
    }

    var backgroundImage: ImageResource {
        switch self {
        case .breakingBad: .breakingbad
        case .betterCallSaul: .bettercallsaul
        }
    }

    var tint: Color {
        switch self {
        case .breakingBad: .green
        case .betterCallSaul: .orange
        }
    }
}
