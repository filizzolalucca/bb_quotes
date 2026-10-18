//
//  CharacterView.swift
//  bb_quotes
//
//  Created by Lucca Filizzola on 17/10/26.
//

import SwiftUI

struct CharacterView: View {
    let character: Char
    let death: Death?
    let show: Show

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    gallery

                    VStack(alignment: .leading, spacing: 4) {
                        Text(character.name)
                            .font(.largeTitle.bold())
                        Text("Portrayed by \(character.portrayedBy)")
                            .foregroundStyle(.secondary)
                    }

                    Divider()

                    infoSection("Born") {
                        Text(character.birthday)
                    }

                    infoSection("Occupations") {
                        bulletList(character.occupations)
                    }

                    infoSection("Nicknames") {
                        bulletList(character.aliases.isEmpty ? ["None"] : character.aliases)
                    }

                    Divider()

                    infoSection("Status") {
                        Text(character.status)
                            .foregroundStyle(character.isDead ? .red : .green)
                    }

                    if let death {
                        deathSection(death)
                    }
                }
                .padding()
                .frame(maxWidth: 700, alignment: .leading)
                .frame(maxWidth: .infinity)
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .tint(show.tint)
    }

    private var gallery: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 12) {
                ForEach(character.images, id: \.self) { url in
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 240, height: 320)
                    .background(.quaternary)
                    .clipShape(.rect(cornerRadius: 16))
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicators(.hidden)
    }

    private func deathSection(_ death: Death) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            AsyncImage(url: death.image) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
                    .frame(maxWidth: .infinity, minHeight: 200)
            }
            .clipShape(.rect(cornerRadius: 16))

            infoSection("Cause of death") {
                Text(death.cause)
            }

            infoSection("How it happened") {
                Text(death.details)
            }

            infoSection("Last words") {
                Text("\u{201C}\(death.lastWords)\u{201D}")
                    .italic()
            }
        }
    }

    private func infoSection(_ title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
                .foregroundStyle(show.tint)
            content()
        }
    }

    private func bulletList(_ items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(items, id: \.self) { item in
                Text("• \(item)")
            }
        }
    }
}

#Preview {
    CharacterView(character: SampleData.character, death: SampleData.death, show: .breakingBad)
        .preferredColorScheme(.dark)
}
