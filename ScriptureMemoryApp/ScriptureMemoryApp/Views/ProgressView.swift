import SwiftUI

struct ProgressView: View {
    @EnvironmentObject private var store: ScriptureStore

    var body: some View {
        NavigationStack {
            List {
                Section {
                    StatRow(title: "经文总数", value: "\(store.verses.count)")
                    StatRow(title: "已背过", value: "\(store.memorizedCount)")
                    StatRow(title: "收藏", value: "\(store.favoriteVerses.count)")
                }

                Section("最近复习") {
                    let reviewed = store.verses
                        .filter { store.progress(for: $0).lastReviewedAt != nil }
                        .sorted {
                            (store.progress(for: $0).lastReviewedAt ?? .distantPast) >
                                (store.progress(for: $1).lastReviewedAt ?? .distantPast)
                        }

                    if reviewed.isEmpty {
                        Text("完成一次背诵后，这里会显示复习记录。")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(reviewed) { verse in
                            VerseRow(verse: verse)
                        }
                    }
                }
            }
            .navigationTitle("进度")
        }
    }
}

private struct StatRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .font(.headline)
                .foregroundColor(.accentColor)
        }
    }
}
