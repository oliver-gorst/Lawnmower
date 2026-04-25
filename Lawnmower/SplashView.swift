import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var logoOpacity = 0.0
    @State private var logoOffset: CGFloat = -20
    @State private var grassHeight: CGFloat = 0
    @State private var blade2Height: CGFloat = 0
    @State private var blade3Height: CGFloat = 0
    @State private var blade4Height: CGFloat = 0

    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.4, green: 0.8, blue: 0.4),
                        Color(red: 0.1, green: 0.5, blue: 0.1)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                GeometryReader { geo in
                    ZStack(alignment: .bottom) {

                        // Back row - darkest
                        ForEach(0..<16, id: \.self) { i in
                            GrassBlade(
                                height: grassHeight * CGFloat.random(in: 0.6...1.0),
                                width: 16,
                                color: Color(red: 0.08, green: 0.38, blue: 0.08),
                                curve: i % 2 == 0 ? 7.0 : -7.0
                            )
                            .offset(x: CGFloat(i) * (geo.size.width / 15) - 8)
                        }

                        // Second row
                        ForEach(0..<14, id: \.self) { i in
                            GrassBlade(
                                height: blade2Height * CGFloat.random(in: 0.6...1.0),
                                width: 20,
                                color: Color(red: 0.1, green: 0.45, blue: 0.1),
                                curve: i % 2 == 0 ? 10.0 : -10.0
                            )
                            .offset(x: CGFloat(i) * (geo.size.width / 13) - 5)
                        }

                        // Third row
                        ForEach(0..<12, id: \.self) { i in
                            GrassBlade(
                                height: blade3Height * CGFloat.random(in: 0.7...1.0),
                                width: 24,
                                color: Color(red: 0.2, green: 0.62, blue: 0.15),
                                curve: i % 2 == 0 ? 13.0 : -13.0
                            )
                            .offset(x: CGFloat(i) * (geo.size.width / 11) + 5)
                        }

                        // Front row - brightest
                        ForEach(0..<10, id: \.self) { i in
                            GrassBlade(
                                height: blade4Height * CGFloat.random(in: 0.8...1.0),
                                width: 28,
                                color: Color(red: 0.3, green: 0.75, blue: 0.2),
                                curve: i % 2 == 0 ? 16.0 : -16.0
                            )
                            .offset(x: CGFloat(i) * (geo.size.width / 9) + 15)
                        }
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                }
                .ignoresSafeArea()

                VStack(spacing: 16) {
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)

                    Text("Lawnmower")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
                }
                .offset(y: logoOffset)
                .opacity(logoOpacity)
            }
            .onAppear {
                withAnimation(.easeOut(duration: 1.8)) {
                    grassHeight = 180
                }
                withAnimation(.easeOut(duration: 2.0).delay(0.15)) {
                    blade2Height = 160
                }
                withAnimation(.easeOut(duration: 2.1).delay(0.3)) {
                    blade3Height = 145
                }
                withAnimation(.easeOut(duration: 2.2).delay(0.45)) {
                    blade4Height = 130
                }
                withAnimation(.easeOut(duration: 0.8).delay(1.4)) {
                    logoOpacity = 1.0
                    logoOffset = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        isActive = true
                    }
                }
            }
        }
    }
}

struct GrassBlade: View {
    let height: CGFloat
    let width: CGFloat
    let color: Color
    let curve: CGFloat

    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: width / 2, y: height))
            path.addQuadCurve(
                to: CGPoint(x: width / 2 + curve, y: 0),
                control: CGPoint(x: width / 2 + curve * 0.8, y: height * 0.5)
            )
            path.addLine(to: CGPoint(x: width / 2 + curve + width * 0.3, y: 0))
            path.addQuadCurve(
                to: CGPoint(x: width, y: height),
                control: CGPoint(x: width / 2 + curve * 0.8 + width * 0.3, y: height * 0.5)
            )
            path.closeSubpath()
        }
        .fill(color)
        .frame(width: width, height: height)
    }
}

#Preview {
    SplashView()
}
