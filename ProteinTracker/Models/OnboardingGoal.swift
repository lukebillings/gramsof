import Foundation

enum OnboardingGoal: String, CaseIterable, Identifiable {
    case buildMuscle
    case loseFat
    case maintain
    case feelHealthier

    var id: String { rawValue }

    var title: String {
        switch self {
        case .buildMuscle: "Build muscle"
        case .loseFat: "Lose fat"
        case .maintain: "Maintain weight"
        case .feelHealthier: "Eat healthier"
        }
    }

    var detail: String {
        switch self {
        case .buildMuscle: "Hit a higher target to support your training."
        case .loseFat: "Stay full and hold onto muscle in a deficit."
        case .maintain: "Keep a steady intake, day after day."
        case .feelHealthier: "Build one simple habit that sticks."
        }
    }

    var symbol: String {
        switch self {
        case .buildMuscle: "figure.strengthtraining.traditional"
        case .loseFat: "figure.run"
        case .maintain: "scalemass.fill"
        case .feelHealthier: "heart.fill"
        }
    }
}
