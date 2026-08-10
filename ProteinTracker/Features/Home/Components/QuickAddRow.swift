import SwiftUI

struct QuickAddRow: View {
    let item: QuickAddItem
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.name)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(AppTheme.ink)
                    Text(item.detail)
                        .font(.caption)
                        .foregroundStyle(AppTheme.ink.opacity(0.5))
                }

                Spacer(minLength: 8)

                Text("\(item.grams)g")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.forest)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(AppTheme.mint, in: .capsule)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 20))
        .accessibilityLabel("Add \(item.name), \(item.grams) grams")
    }
}

#Preview {
    QuickAddRow(item: QuickAddItem.favourites[0]) {}
        .padding()
        .background(AppTheme.background)
}
