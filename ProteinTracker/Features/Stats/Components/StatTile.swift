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

            Text(value)
                .font(.title2.weight(.bold))
                .foregroundStyle(AppTheme.ink)

            if let detail {
                Text(detail)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(AppTheme.ink.opacity(0.5))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .glassEffect(.regular, in: .rect(cornerRadius: 22))
    }
}

#Preview {
    HStack {
        StatTile(label: "Average protein intake per day", value: "148g")
        StatTile(label: "Days reached goal", value: "5/7")
    }
    .padding()
    .background(AppTheme.background)
}
