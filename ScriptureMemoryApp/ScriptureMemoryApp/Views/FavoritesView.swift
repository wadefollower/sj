import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var store: ScriptureStore

    var body: some View {
        NavigationStack {
            Group {
                if store.favoriteVerses.isEmpty {
                    ContentUnavailableView("还没有收藏", systemImage: "star", description: Text("在背诵页面点亮星标，经文会出现在这里。"))
                } else {
                    List(store.favoriteVerses) { verse in
                        NavigationLink {
                            MemorizeView(verse: verse)
                        } label: {
                            VerseRow(verse: verse)
                        }
                    }
                }
            }
            .navigationTitle("收藏")
        }
    }
}
