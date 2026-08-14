import SwiftUI

struct QuickAddTile: View {
    let item: QuickAddItem
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top, spacing: 8) {
                    Text(item.emoji)
                        .font(.title3)
                        .frame(width: 34, height: 34)
                        .background(AppTheme.mint.opacity(0.45), in: .circle)

                    Spacer(minLength: 0)

                    Text("+\(item.grams)g")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(AppTheme.forest)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(AppTheme.mint, in: .capsule)
                }

                Text(item.portionDescription)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(AppTheme.ink)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                    .minimumScaleFactor(0.85)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(12)
            .frame(maxWidth: .infinity, minHeight: 92, alignment: .topLeading)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 16))
        .accessibilityLabel("Add \(item.portionDescription), \(item.grams) grams of protein")
    }
}

#Preview {
    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 2), spacing: 8) {
        ForEach(QuickAddItem.defaults) { item in
            QuickAddTile(item: item) {}
        }
    }
    .padding()
    .background(AppTheme.background)
}
