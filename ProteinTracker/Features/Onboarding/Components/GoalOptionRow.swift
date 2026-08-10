import SwiftUI

struct GoalOptionRow: View {
    let goal: OnboardingGoal
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: goal.symbol)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(isSelected ? AppTheme.forest : AppTheme.ink.opacity(0.55))
                    .frame(width: 42, height: 42)
                    .background(AppTheme.mint.opacity(isSelected ? 1 : 0.4), in: .circle)

                VStack(alignment: .leading, spacing: 2) {
                    Text(goal.title)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(AppTheme.ink)

                    Text(goal.detail)
                        .font(.caption)
                        .foregroundStyle(AppTheme.ink.opacity(0.5))
                        .multilineTextAlignment(.leading)
                }

                Spacer(minLength: 8)

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isSelected ? AppTheme.emerald : AppTheme.ink.opacity(0.2))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(AppTheme.emerald.opacity(isSelected ? 1 : 0), lineWidth: 2)
        }
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    VStack(spacing: 10) {
        GoalOptionRow(goal: .buildMuscle, isSelected: true) {}
        GoalOptionRow(goal: .loseFat, isSelected: false) {}
    }
    .padding()
    .background(AppTheme.background)
}
