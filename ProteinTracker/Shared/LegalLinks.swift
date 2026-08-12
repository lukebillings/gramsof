import Foundation

enum LegalLinks {
    private static let site = "https://lukebillings.github.io/gramsof"

    static let termsAndConditions = URL(string: "\(site)/termsandconditions/")!
    static let privacyPolicy = URL(string: "\(site)/privacypolicy/")!
    static let termsOfService = URL(string: "\(site)/termsandconditions/")!
    static let featureRequest = URL(string: "mailto:gramsof.app@outlook.com?subject=Gramsof%20feature%20request")!
}
