import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color(red: 0.08, green: 0.28, blue: 0.20)
                .ignoresSafeArea()

            foodOrbit

            VStack(spacing: 16) {
                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 112, height: 112)
                    .clipShape(.rect(cornerRadius: 28))
                    .shadow(color: .black.opacity(0.28), radius: 18, y: 10)

                Text("Gramsof")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                Text("Track your protein")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white.opacity(0.72))
            }
        }
    }

    private var foodOrbit: some View {
        ZStack {
            splashFood("SplashProteinShake", size: 88)
                .offset(x: -118, y: -168)
                .rotationEffect(.degrees(-12))

            splashFood("SplashAvocado", size: 78)
                .offset(x: 120, y: -150)
                .rotationEffect(.degrees(10))

            splashFood("SplashSalmon", size: 92)
                .offset(x: -110, y: 170)
                .rotationEffect(.degrees(8))

            splashFood("SplashGreekYogurt", size: 84)
                .offset(x: 115, y: 160)
                .rotationEffect(.degrees(-9))
        }
        .allowsHitTesting(false)
    }

    private func splashFood(_ name: String, size: CGFloat) -> some View {
        Image(name)
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .clipShape(.rect(cornerRadius: size * 0.28))
            .overlay {
                RoundedRectangle(cornerRadius: size * 0.28)
                    .strokeBorder(.white.opacity(0.22), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.35), radius: 14, y: 8)
            .opacity(0.92)
    }
}

#Preview {
    SplashView()
}
