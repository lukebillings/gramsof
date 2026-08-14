import SwiftUI

/// Full-screen celebration shown the first time today’s protein goal is met.
struct GoalReachedCelebrationView: View {
    let streak: Int
    var onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture(perform: onDismiss)

            VStack(spacing: 20) {
                flickeringFlame
                    .padding(.bottom, 4)

                Text("Congratulations")
                    .font(.title.weight(.bold))
                    .foregroundStyle(AppTheme.ink)
                    .multilineTextAlignment(.center)

                Text("You have reached your protein goal for today.")
                    .font(.body)
                    .foregroundStyle(AppTheme.ink.opacity(0.65))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)

                if streak > 0 {
                    HStack(spacing: 6) {
                        Image(systemName: "flame.fill")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(AppTheme.emerald)

                        Text("\(streak)-day streak")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(AppTheme.ink)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .glassEffect(.regular, in: .capsule)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("Streak \(streak) days")
                }

                Button(action: onDismiss) {
                    Text("Nice")
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.glassProminent)
                .tint(AppTheme.emerald)
                .padding(.top, 4)
            }
            .padding(24)
            .glassEffect(.regular, in: .rect(cornerRadius: 32))
            .padding(.horizontal, 28)
        }
        .accessibilityAddTraits(.isModal)
        .onAppear {
            AppHaptics.notification(.success)
        }
    }

    private var flickeringFlame: some View {
        TimelineView(.animation) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            let flicker = 0.94 + 0.06 * sin(t * 9) + 0.03 * sin(t * 17)

            ZStack {
                Circle()
                    .fill(AppTheme.emerald.opacity(0.28))
                    .frame(width: 132, height: 132)
                    .blur(radius: 22)
                    .scaleEffect(flicker)

                Image(systemName: "flame.fill")
                    .font(.system(size: 72, weight: .semibold))
                    .foregroundStyle(AppTheme.emerald)
                    .scaleEffect(flicker)
                    .shadow(color: AppTheme.emerald.opacity(0.45), radius: 18)
                    .accessibilityHidden(true)
            }
        }
        .frame(height: 132)
        .accessibilityLabel("Streak flame")
    }
}

#Preview {
    ZStack {
        AppTheme.background
        GoalReachedCelebrationView(streak: 3, onDismiss: {})
    }
}
