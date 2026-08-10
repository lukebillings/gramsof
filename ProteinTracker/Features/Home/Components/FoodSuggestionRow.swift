import SwiftUI

struct FoodSuggestionRow: View {
    let suggestion: FoodSuggestion
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(suggestion.emoji)
                    .font(.title3)
                    .frame(width: 38, height: 38)
                    .background(AppTheme.mint.opacity(0.45), in: .circle)

                VStack(alignment: .leading, spacing: 2) {
                    Text(suggestion.name)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(AppTheme.ink)
                    Text(suggestion.portionLabel)
                        .font(.caption)
                        .foregroundStyle(AppTheme.ink.opacity(0.5))
                }

                Spacer(minLength: 8)

                Text("+\(suggestion.grams)g")
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
        .accessibilityLabel("Log \(suggestion.name), \(suggestion.portionLabel), \(suggestion.grams) grams of protein")
    }
}

#Preview {
    VStack(spacing: 10) {
        ForEach(FoodLookup.suggestions(for: "chicken")) { suggestion in
            FoodSuggestionRow(suggestion: suggestion) {}
        }
    }
    .padding()
    .background(AppTheme.background)
}
