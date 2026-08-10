import SwiftUI

struct LoggedEntryRow: View {
    let entry: ProteinEntry

    var body: some View {
        HStack(spacing: 12) {
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
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

#Preview {
    LoggedEntryRow(entry: ProteinEntry(name: "Protein shake", grams: 25))
        .background(AppTheme.background)
}
