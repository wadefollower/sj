import SwiftUI

struct VerseRow: View {
    @EnvironmentObject private var store: ScriptureStore
    let verse: Verse

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(verse.reference)
                    .font(.headline)
                Spacer()
                if store.isFavorite(verse) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                }
            }

            Text(verse.text)
                .font(.body)
                .foregroundStyle(.primary)
                .lineLimit(2)

            HStack(spacing: 8) {
                Text(verse.theme)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.thinMaterial, in: Capsule())

                let progress = store.progress(for: verse)
                if progress.isMemorized {
                    Label("已背过", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.green)
                } else if progress.reviewCount > 0 {
                    Label("复习 \(progress.reviewCount) 次", systemImage: "arrow.clockwise")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 6)
    }
}
