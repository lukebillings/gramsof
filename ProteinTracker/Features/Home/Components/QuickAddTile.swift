import SwiftUI

struct QuickAddTile: View {
    let item: QuickAddItem
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(item.emoji)
                    .font(.title3)
                    .frame(width: 34, height: 34)
                    .background(AppTheme.mint.opacity(0.45), in: .circle)

                Text(item.portionDescription)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(AppTheme.ink)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
                    .frame(maxWidth: .infinity, minHeight: 28, alignment: .top)

                Spacer(minLength: 0)

                Text("+\(item.grams)g")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(AppTheme.forest)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(AppTheme.mint, in: .capsule)
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, minHeight: 118, maxHeight: .infinity, alignment: .top)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 16))
        .accessibilityLabel("Add \(item.portionDescription), \(item.grams) grams of protein")
    }
}

#Preview {
    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4), spacing: 8) {
        ForEach(QuickAddItem.defaults) { item in
            QuickAddTile(item: item) {}
        }
    }
    .padding()
    .background(AppTheme.background)
}
