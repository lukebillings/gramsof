import SwiftUI

struct StatTile: View {
    let label: String
    let value: String
    var detail: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label.uppercased())
                .font(.caption2.weight(.semibold))
                .foregroundStyle(AppTheme.ink.opacity(0.5))
                .lineLimit(2)
                .minimumScaleFactor(0.85)
                .frame(minHeight: 28, alignment: .topLeading)

            Text(value)
                .font(.title2.weight(.bold))
                .foregroundStyle(AppTheme.ink)

            Text(detail ?? " ")
                .font(.caption.weight(.medium))
                .foregroundStyle(detail == nil ? .clear : AppTheme.ink.opacity(0.5))
                .accessibilityHidden(detail == nil)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(16)
        .glassEffect(.regular, in: .rect(cornerRadius: 22))
    }
}

#Preview {
    VStack(spacing: 12) {
        HStack(spacing: 12) {
            StatTile(label: "Average protein intake per day", value: "148g")
            StatTile(label: "Days reached goal", value: "5/7")
        }
        HStack(spacing: 12) {
            StatTile(label: "Highest protein intake", value: "182g", detail: "Tue 11 Aug")
            StatTile(label: "Goal reached streak", value: "0 days")
        }
    }
    .padding()
    .background(AppTheme.background)
}
