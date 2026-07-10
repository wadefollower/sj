import SwiftUI

struct MemorizeView: View {
    @EnvironmentObject private var store: ScriptureStore
    let verse: Verse

    @State private var mode: MemorizationMode = .fullText
    @State private var hintLevel = 0
    @State private var answer = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header

                Picker("模式", selection: $mode) {
                    ForEach(MemorizationMode.allCases) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)

                scriptureCard

                actionButtons

                progressCard
            }
            .padding()
        }
        .navigationTitle(verse.reference)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                store.toggleFavorite(verse)
            } label: {
                Image(systemName: store.isFavorite(verse) ? "star.fill" : "star")
            }
            .accessibilityLabel(store.isFavorite(verse) ? "取消收藏" : "收藏")
        }
        .onChange(of: mode) {
            hintLevel = 0
            answer = ""
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(verse.reference)
                .font(.largeTitle.bold())

            Text(verse.theme)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var scriptureCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            switch mode {
            case .fullText:
                Text(verse.text)
                    .font(.title3)
                    .lineSpacing(8)
                    .textSelection(.enabled)

            case .blanks:
                Text(maskedText)
                    .font(.title3)
                    .lineSpacing(8)
                    .textSelection(.enabled)

            case .initials:
                Text(initialText)
                    .font(.title3)
                    .lineSpacing(8)
                    .textSelection(.enabled)

            case .selfTest:
                TextEditor(text: $answer)
                    .frame(minHeight: 180)
                    .padding(10)
                    .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8))
                    .overlay(alignment: .topLeading) {
                        if answer.isEmpty {
                            Text("默写这节经文")
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 18)
                                .allowsHitTesting(false)
                        }
                    }

                Text(compareText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGroupedBackground), in: RoundedRectangle(cornerRadius: 8))
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            if mode == .blanks || mode == .initials {
                Button {
                    hintLevel = min(hintLevel + 1, 3)
                } label: {
                    Label("显示更多提示", systemImage: "lightbulb")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }

            Button {
                store.markReviewed(verse, memorized: true)
            } label: {
                Label("标记为已背过", systemImage: "checkmark.circle.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            Button(role: .destructive) {
                store.resetProgress(verse)
            } label: {
                Label("重置这节进度", systemImage: "arrow.counterclockwise")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
    }

    private var progressCard: some View {
        let progress = store.progress(for: verse)

        return VStack(alignment: .leading, spacing: 10) {
            Label(progress.isMemorized ? "已背过" : "还在练习", systemImage: progress.isMemorized ? "checkmark.seal.fill" : "clock")
                .font(.headline)

            Text("复习次数：\(progress.reviewCount)")
                .foregroundStyle(.secondary)

            if let date = progress.lastReviewedAt {
                Text("上次复习：\(date.formatted(date: .abbreviated, time: .shortened))")
                    .foregroundStyle(.secondary)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8))
    }

    private var maskedText: String {
        let visibleStride = max(2, 5 - hintLevel)
        return verse.text.enumerated().map { index, character in
            guard character.isChineseText else {
                return String(character)
            }

            return index % visibleStride == 0 ? String(character) : "＿"
        }.joined()
    }

    private var initialText: String {
        let chunkSize = max(2, 6 - hintLevel)
        let characters = Array(verse.text)
        var output: [String] = []

        for index in characters.indices {
            let character = characters[index]
            guard character.isChineseText else {
                output.append(String(character))
                continue
            }

            output.append(index % chunkSize == 0 ? String(character) : "·")
        }

        return output.joined()
    }

    private var compareText: String {
        guard answer.isEmpty == false else {
            return "输入后可以自己对照原文。"
        }

        let typed = answer.normalizedForComparison
        let source = verse.text.normalizedForComparison

        if typed == source {
            return "和原文一致。"
        }

        return "原文：\(verse.text)"
    }
}

private extension Character {
    var isChineseText: Bool {
        unicodeScalars.contains { scalar in
            scalar.value >= 0x4E00 && scalar.value <= 0x9FFF
        }
    }
}

private extension String {
    var normalizedForComparison: String {
        filter { $0.isChineseText }
    }
}
