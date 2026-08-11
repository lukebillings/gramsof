import SwiftUI

struct ProteinRingView: View {
    let total: Int
    let goal: Int
    let progress: Double

    private let lineWidth: CGFloat = 24

    var body: some View {
        ZStack {
            Circle()
                .stroke(AppTheme.forest.opacity(0.12), lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: min(progress, 1))
                .stroke(
                    AppTheme.ringGradient(progress: progress),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            VStack(spacing: 2) {
                Text("\(total)")
                    .font(.system(size: 68, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.ink)
                    .contentTransition(.numericText())

                Text("of \(goal)g")
                    .font(.headline)
                    .foregroundStyle(AppTheme.ink.opacity(0.5))
            }
        }
        .frame(width: 220, height: 220)
        .animation(.smooth, value: progress)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Protein today")
        .accessibilityValue("\(total) of \(goal) grams")
    }
}

#Preview {
    ProteinRingView(total: 98, goal: 150, progress: 98.0 / 150.0)
        .padding()
        .background(AppTheme.background)
}
