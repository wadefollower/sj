import SwiftUI

struct LibraryView: View {
    @EnvironmentObject private var store: ScriptureStore
    @State private var searchText = ""

    private var filteredVerses: [Verse] {
        guard searchText.isEmpty == false else {
            return store.verses
        }

        return store.verses.filter {
            $0.reference.localizedStandardContains(searchText)
                || $0.text.localizedStandardContains(searchText)
                || $0.theme.localizedStandardContains(searchText)
        }
    }

    private var groupedVerses: [(String, [Verse])] {
        Dictionary(grouping: filteredVerses, by: \.theme)
            .sorted { $0.key < $1.key }
            .map { ($0.key, $0.value) }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(groupedVerses, id: \.0) { theme, verses in
                    Section(theme) {
                        ForEach(verses) { verse in
                            NavigationLink {
                                MemorizeView(verse: verse)
                            } label: {
                                VerseRow(verse: verse)
                            }
                        }
                    }
                }
            }
            .navigationTitle("经文库")
            .searchable(text: $searchText, prompt: "搜索经文、主题或出处")
        }
    }
}
