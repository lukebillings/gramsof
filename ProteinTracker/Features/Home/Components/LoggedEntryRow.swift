import SwiftUI

struct LoggedEntryRow: View {
    let entry: ProteinEntry
    var onTap: (() -> Void)? = nil

    var body: some View {
        Button {
            onTap?()
        } label: {
            HStack(spacing: 12) {
                Text(entry.emoji)
                    .font(.body)
                    .frame(width: 32, height: 32)
                    .background(AppTheme.mint.opacity(0.45), in: .circle)

                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.name)
                        .font(.body.weight(.medium))
                        .foregroundStyle(AppTheme.ink)
                    Text(entry.loggedAt, format: .dateTime.hour().minute())
                        .font(.caption)
                        .foregroundStyle(AppTheme.ink.opacity(0.5))
                }

                Spacer(minLength: 8)

                Text("+\(entry.grams)g")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppTheme.emerald)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .disabled(onTap == nil)
        .accessibilityLabel("\(entry.name), \(entry.grams) grams")
        .accessibilityHint("Double tap to edit or delete")
    }
}

#Preview {
    LoggedEntryRow(entry: ProteinEntry(name: "Protein shake", grams: 25)) {}
        .background(AppTheme.background)
}
