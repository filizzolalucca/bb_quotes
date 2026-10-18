//
//  ContentView.swift
//  bb_quotes
//
//  Created by Lucca Filizzola on 11/08/26.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedShow: Show = .breakingBad

    var body: some View {
        TabView(selection: $selectedShow) {
            ForEach(Show.allCases) { show in
                Tab(show.title, systemImage: show.symbol, value: show) {
                    QuoteView(show: show)
                }
            }
        }
        .tint(selectedShow.tint)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
