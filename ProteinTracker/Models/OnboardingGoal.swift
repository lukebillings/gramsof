import Foundation

enum OnboardingGoal: String, CaseIterable, Identifiable {
    case buildMuscle
    case loseFat
    case maintain
    case feelHealthier
    case other

    var id: String { rawValue }

    var title: String {
        switch self {
        case .buildMuscle: "Build muscle"
        case .loseFat: "Lose fat"
        case .maintain: "Maintain weight"
        case .feelHealthier: "Eat healthier"
        case .other: "Other"
        }
    }

    var symbol: String {
        switch self {
        case .buildMuscle: "figure.strengthtraining.traditional"
        case .loseFat: "figure.run"
        case .maintain: "scalemass.fill"
        case .feelHealthier: "heart.fill"
        case .other: "ellipsis.circle.fill"
        }
    }
}
