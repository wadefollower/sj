import SwiftUI

@main
struct ScriptureMemoryAppApp: App {
    @StateObject private var store = ScriptureStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
        }
    }
}
