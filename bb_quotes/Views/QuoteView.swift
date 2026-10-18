//
//  QuoteView.swift
//  bb_quotes
//
//  Created by Lucca Filizzola on 17/10/26.
//

import SwiftUI

struct QuoteView: View {
    let show: Show

    @State private var viewModel = QuoteViewModel()
    @State private var isShowingCharacter = false

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            switch viewModel.status {
            case .notStarted:
                EmptyView()

            case .fetching:
                ProgressView()
                    .controlSize(.large)

            case .success:
                if let quote = viewModel.quote {
                    quoteCard(quote)
                    characterButton(for: quote)
                }

            case .failed(let error):
                Label(error.localizedDescription, systemImage: "wifi.exclamationmark")
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(.black.opacity(0.6), in: .rect(cornerRadius: 16))
            }

            Spacer()

            Button {
                Task { await viewModel.getData(for: show) }
            } label: {
                Text("Get Random Quote")
                    .font(.headline)
                    .padding(.horizontal, 8)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(show.tint)
            .disabled(viewModel.isFetching)
        }
        .padding()
        .frame(maxWidth: 600)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(.white)
        .background {
            Color.clear
                .overlay {
                    Image(show.backgroundImage)
                        .resizable()
                        .scaledToFill()
                }
                .overlay(.black.opacity(0.45))
                .clipped()
                .ignoresSafeArea()
        }
        .task {
            if case .notStarted = viewModel.status {
                await viewModel.getData(for: show)
            }
        }
        .sheet(isPresented: $isShowingCharacter) {
            if let character = viewModel.character {
                CharacterView(character: character, death: viewModel.death, show: show)
            }
        }
    }

    private func quoteCard(_ quote: Quote) -> some View {
        Text("\u{201C}\(quote.quote)\u{201D}")
            .font(.title2)
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.6)
            .padding()
            .background(.black.opacity(0.6), in: .rect(cornerRadius: 20))
    }

    private func characterButton(for quote: Quote) -> some View {
        Button {
            isShowingCharacter = true
        } label: {
            VStack(spacing: 8) {
                AsyncImage(url: viewModel.character?.images.first) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Image(systemName: "person.fill")
                            .font(.largeTitle)
                    default:
                        if viewModel.character == nil {
                            Image(systemName: "person.fill")
                                .font(.largeTitle)
                        } else {
                            ProgressView()
                        }
                    }
                }
                .frame(width: 180, height: 240)
                .background(.black.opacity(0.4))
                .clipShape(.rect(cornerRadius: 20))

                Text(quote.character)
                    .font(.headline)

                Text("\(show.title) · \(quote.episodeCode)")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))
            }
        }
        .buttonStyle(.plain)
        .disabled(viewModel.character == nil)
        .accessibilityHint("Shows details about \(quote.character)")
    }
}

#Preview {
    QuoteView(show: .breakingBad)
        .preferredColorScheme(.dark)
}
