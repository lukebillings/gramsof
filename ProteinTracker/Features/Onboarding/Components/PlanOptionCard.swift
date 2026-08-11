import SwiftUI

struct PlanOptionCard: View {
    let plan: SubscriptionPlan
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 14) {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .font(.title3)
                    .foregroundStyle(isSelected ? AppTheme.emerald : AppTheme.ink.opacity(0.2))

                switch plan {
                case .annual:
                    annualContent
                case .monthly:
                    monthlyContent
                }
            }
            .padding(16)
            .padding(.top, plan.badge == nil ? 0 : 6)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 22))
        .overlay {
            RoundedRectangle(cornerRadius: 22)
                .strokeBorder(AppTheme.emerald.opacity(isSelected ? 1 : 0), lineWidth: 2)
        }
        .overlay(alignment: .topTrailing) {
            if let badge = plan.badge {
                Text(badge)
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(AppTheme.forest)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(AppTheme.mint, in: .capsule)
                    .overlay {
                        Capsule()
                            .strokeBorder(AppTheme.emerald.opacity(isSelected ? 0.55 : 0.25), lineWidth: 1)
                    }
                    .offset(x: -12, y: -10)
            }
        }
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityLabel(accessibilityLabel)
    }

    private var annualContent: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("7 days free trial")
                    .font(.body.weight(.bold))
                    .foregroundStyle(AppTheme.ink)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Text(plan.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppTheme.ink.opacity(0.65))
            }

            Spacer(minLength: 8)

            VStack(alignment: .trailing, spacing: 2) {
                Text("£49.99 per year")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(AppTheme.ink.opacity(0.45))
                    .multilineTextAlignment(.trailing)

                if let effective = plan.effectiveMonthlyLabel {
                    Text(effective)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(AppTheme.ink.opacity(0.45))
                }
            }
        }
    }

    private var monthlyContent: some View {
        HStack(alignment: .center, spacing: 12) {
            Text(plan.title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppTheme.ink.opacity(0.65))

            Spacer(minLength: 8)

            Text(plan.priceSummary)
                .font(.caption.weight(.medium))
                .foregroundStyle(AppTheme.ink.opacity(0.45))
                .multilineTextAlignment(.trailing)
        }
    }

    private var accessibilityLabel: String {
        switch plan {
        case .annual:
            return "7 days free trial, Yearly, Save 58% vs monthly, £49.99 per year"
        case .monthly:
            return "\(plan.title), \(plan.priceSummary)"
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        PlanOptionCard(plan: .annual, isSelected: true) {}
        PlanOptionCard(plan: .monthly, isSelected: false) {}
    }
    .padding()
    .background(AppTheme.background)
}
