import Foundation

@MainActor
final class ScriptureStore: ObservableObject {
    @Published private(set) var verses: [Verse] = []
    @Published private(set) var favorites: Set<String> = []
    @Published private(set) var progressByVerseID: [String: VerseProgress] = [:]

    private let storageKey = "scripture-memory.snapshot.v1"

    init() {
        loadVerses()
        loadSnapshot()
    }

    var favoriteVerses: [Verse] {
        verses.filter { favorites.contains($0.id) }
    }

    var memorizedCount: Int {
        progressByVerseID.values.filter(\.isMemorized).count
    }

    var todayVerses: [Verse] {
        let unfinished = verses.filter { progress(for: $0).isMemorized == false }
        return Array((unfinished.isEmpty ? verses : unfinished).prefix(3))
    }

    func progress(for verse: Verse) -> VerseProgress {
        progressByVerseID[verse.id] ?? .empty(for: verse.id)
    }

    func isFavorite(_ verse: Verse) -> Bool {
        favorites.contains(verse.id)
    }

    func toggleFavorite(_ verse: Verse) {
        if favorites.contains(verse.id) {
            favorites.remove(verse.id)
        } else {
            favorites.insert(verse.id)
        }
        saveSnapshot()
    }

    func markReviewed(_ verse: Verse, memorized: Bool) {
        var progress = progress(for: verse)
        progress.reviewCount += 1
        progress.isMemorized = memorized
        progress.lastReviewedAt = Date()
        progressByVerseID[verse.id] = progress
        saveSnapshot()
    }

    func resetProgress(_ verse: Verse) {
        progressByVerseID[verse.id] = .empty(for: verse.id)
        saveSnapshot()
    }

    private func loadVerses() {
        guard let url = Bundle.main.url(forResource: "cuv_sample", withExtension: "json") else {
            verses = Self.fallbackVerses
            return
        }

        do {
            let data = try Data(contentsOf: url)
            verses = try JSONDecoder().decode([Verse].self, from: data)
        } catch {
            verses = Self.fallbackVerses
        }
    }

    private func loadSnapshot() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            favorites = []
            progressByVerseID = [:]
            return
        }

        do {
            let snapshot = try JSONDecoder().decode(ScriptureSnapshot.self, from: data)
            favorites = snapshot.favoriteVerseIDs
            progressByVerseID = snapshot.progressByVerseID
        } catch {
            favorites = []
            progressByVerseID = [:]
        }
    }

    private func saveSnapshot() {
        let snapshot = ScriptureSnapshot(
            favoriteVerseIDs: favorites,
            progressByVerseID: progressByVerseID
        )

        guard let data = try? JSONEncoder().encode(snapshot) else {
            return
        }

        UserDefaults.standard.set(data, forKey: storageKey)
    }

    private static let fallbackVerses: [Verse] = [
        Verse(book: "约翰福音", chapter: 3, verse: 16, text: "神爱世人，甚至将他的独生子赐给他们，叫一切信他的，不至灭亡，反得永生。", theme: "福音"),
        Verse(book: "诗篇", chapter: 23, verse: 1, text: "耶和华是我的牧者，我必不至缺乏。", theme: "安慰"),
        Verse(book: "腓立比书", chapter: 4, verse: 13, text: "我靠着那加给我力量的，凡事都能做。", theme: "信心")
    ]
}
