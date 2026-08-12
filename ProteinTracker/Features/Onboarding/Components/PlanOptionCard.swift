import SwiftUI

struct PlanOptionCard: View {
    let offer: SubscriptionOffer
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 14) {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .font(.title3)
                    .foregroundStyle(isSelected ? AppTheme.emerald : AppTheme.ink.opacity(0.2))

                if offer.plan == .yearly {
                    yearlyContent
                } else {
                    monthlyContent
                }
            }
            .padding(16)
            .padding(.top, offer.badge == nil ? 0 : 6)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 22))
        .overlay {
            RoundedRectangle(cornerRadius: 22)
                .strokeBorder(AppTheme.emerald.opacity(isSelected ? 1 : 0), lineWidth: 2)
        }
        .overlay(alignment: .topTrailing) {
            if let badge = offer.badge {
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

    private var yearlyContent: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                if let days = offer.freeTrialDays {
                    Text("\(days) days free trial")
                        .font(.body.weight(.bold))
                        .foregroundStyle(AppTheme.ink)
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)

                    Text(offer.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppTheme.ink.opacity(0.65))
                } else {
                    Text(offer.title)
                        .font(.body.weight(.bold))
                        .foregroundStyle(AppTheme.ink)
                }
            }

            Spacer(minLength: 8)

            VStack(alignment: .trailing, spacing: 2) {
                Text(offer.priceSummary)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(AppTheme.ink.opacity(0.45))
                    .multilineTextAlignment(.trailing)

                if let effective = offer.effectiveMonthlyPrice {
                    Text(effective)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(AppTheme.ink.opacity(0.45))
                }
            }
        }
    }

    private var monthlyContent: some View {
        HStack(alignment: .center, spacing: 12) {
            Text(offer.title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppTheme.ink.opacity(0.65))

            Spacer(minLength: 8)

            Text(offer.priceSummary)
                .font(.caption.weight(.medium))
                .foregroundStyle(AppTheme.ink.opacity(0.45))
                .multilineTextAlignment(.trailing)
        }
    }

    private var accessibilityLabel: String {
        let trial = offer.freeTrialDays.map { "\($0) days free trial, " } ?? ""
        let badge = offer.badge.map { ", \($0)" } ?? ""
        return "\(trial)\(offer.title)\(badge), \(offer.priceSummary)"
    }
}
