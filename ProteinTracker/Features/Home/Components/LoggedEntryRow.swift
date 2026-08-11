import SwiftUI

struct LoggedEntryRow: View {
    let entry: ProteinEntry
    var onEditGrams: (() -> Void)? = nil
    var onDelete: (() -> Void)? = nil

    var body: some View {
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

            Button {
                onEditGrams?()
            } label: {
                Text("+\(entry.grams)g")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppTheme.emerald)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .contentShape(.rect)
            }
            .buttonStyle(.plain)
            .disabled(onEditGrams == nil)
            .accessibilityLabel("Edit \(entry.name) grams, currently \(entry.grams)")
            .accessibilityHint("Double tap to change the protein amount")

            if let onDelete {
                Button(role: .destructive, action: onDelete) {
                    Image(systemName: "trash")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.red.opacity(0.85))
                        .padding(8)
                        .contentShape(.rect)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Delete \(entry.name)")
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

#Preview {
    LoggedEntryRow(
        entry: ProteinEntry(name: "Protein shake", grams: 25),
        onEditGrams: {},
        onDelete: {}
    )
    .background(AppTheme.background)
}
