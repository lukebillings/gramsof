import Foundation

enum LegalLinks {
    private static let site = "https://lukebillings.github.io/gramsof"

    static let termsAndConditions = URL(string: "\(site)/termsandconditions/")!
    static let privacyPolicy = URL(string: "\(site)/privacypolicy/")!
    /// Apple’s Standard Licensed Application End User License Agreement.
    static let termsOfUse = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!
    static let featureRequest = URL(string: "mailto:gramsof.app@outlook.com?subject=Gramsof%20feature%20request")!
}
