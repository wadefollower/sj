import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            TodayView()
                .tabItem {
                    Label("今日", systemImage: "sun.max")
                }

            LibraryView()
                .tabItem {
                    Label("经文库", systemImage: "book.closed")
                }

            FavoritesView()
                .tabItem {
                    Label("收藏", systemImage: "star")
                }

            ProgressView()
                .tabItem {
                    Label("进度", systemImage: "chart.bar")
                }
        }
    }
}
