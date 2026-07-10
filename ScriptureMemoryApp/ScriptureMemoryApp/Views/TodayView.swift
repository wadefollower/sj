import SwiftUI

struct TodayView: View {
    @EnvironmentObject private var store: ScriptureStore

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(store.todayVerses) { verse in
                        NavigationLink {
                            MemorizeView(verse: verse)
                        } label: {
                            VerseRow(verse: verse)
                        }
                    }
                } header: {
                    Text("今日背诵")
                }
            }
            .navigationTitle("背经")
        }
    }
}
