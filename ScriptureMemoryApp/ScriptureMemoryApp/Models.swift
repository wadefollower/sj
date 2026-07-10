import Foundation

struct Verse: Identifiable, Codable, Hashable {
    let book: String
    let chapter: Int
    let verse: Int
    let text: String
    let theme: String

    var id: String {
        "\(book)-\(chapter)-\(verse)"
    }

    var reference: String {
        "\(book) \(chapter):\(verse)"
    }
}

struct VerseProgress: Codable, Equatable {
    var verseID: String
    var reviewCount: Int
    var isMemorized: Bool
    var lastReviewedAt: Date?

    static func empty(for verseID: String) -> VerseProgress {
        VerseProgress(
            verseID: verseID,
            reviewCount: 0,
            isMemorized: false,
            lastReviewedAt: nil
        )
    }
}

struct ScriptureSnapshot: Codable {
    var favoriteVerseIDs: Set<String>
    var progressByVerseID: [String: VerseProgress]

    static let empty = ScriptureSnapshot(
        favoriteVerseIDs: [],
        progressByVerseID: [:]
    )
}

enum MemorizationMode: String, CaseIterable, Identifiable {
    case fullText = "全文"
    case blanks = "遮挡"
    case initials = "首字"
    case selfTest = "自测"

    var id: String { rawValue }
}
