import SwiftUI

struct StatTile: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label.uppercased())
                .font(.caption2.weight(.semibold))
                .foregroundStyle(AppTheme.ink.opacity(0.5))

            Text(value)
                .font(.title2.weight(.bold))
                .foregroundStyle(AppTheme.ink)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .glassEffect(.regular, in: .rect(cornerRadius: 22))
    }
}

#Preview {
    HStack {
        StatTile(label: "Avg / day", value: "148g")
        StatTile(label: "Hit rate", value: "5/7")
    }
    .padding()
    .background(AppTheme.background)
}
