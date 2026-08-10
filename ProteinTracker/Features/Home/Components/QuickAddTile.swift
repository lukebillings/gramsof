import SwiftUI

struct QuickAddTile: View {
    let item: QuickAddItem
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Text(item.emoji)
                    .font(.title2)
                    .frame(width: 44, height: 44)
                    .background(AppTheme.mint.opacity(0.45), in: .circle)

                VStack(spacing: 2) {
                    Text(item.name)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppTheme.ink)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.85)

                    Text(item.detail)
                        .font(.caption2)
                        .foregroundStyle(AppTheme.ink.opacity(0.5))
                        .lineLimit(1)
                }

                Text("\(item.grams)g")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(AppTheme.forest)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(AppTheme.mint, in: .capsule)
            }
            .frame(maxWidth: .infinity, minHeight: 140)
            .padding(12)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 20))
        .accessibilityLabel("Add \(item.name), \(item.grams) grams")
    }
}

#Preview {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
        ForEach(QuickAddItem.favourites) { item in
            QuickAddTile(item: item) {}
        }
    }
    .padding()
    .background(AppTheme.background)
}
