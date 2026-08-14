import SwiftUI

struct LoggedEntryColumnHeader: View {
    var body: some View {
        HStack {
            Text("Food")

            Spacer(minLength: 8)

            Text("Grams of protein")
                .multilineTextAlignment(.trailing)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
        }
        .font(.caption.weight(.semibold))
        .foregroundStyle(AppTheme.ink.opacity(0.45))
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 6)
        .accessibilityElement(children: .combine)
    }
}

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
                    Text(entry.displayName)
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
                    .accessibilityLabel("\(entry.grams) grams of protein")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .disabled(onTap == nil)
        .accessibilityLabel("\(entry.displayName), \(entry.grams) grams of protein")
        .accessibilityHint("Double tap to edit grams of protein or delete")
    }
}

#Preview {
    LoggedEntryRow(entry: ProteinEntry(name: "Protein shake", grams: 25)) {}
        .background(AppTheme.background)
}
