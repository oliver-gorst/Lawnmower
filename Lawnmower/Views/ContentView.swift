import SwiftUI

struct ContentView: View {

    func greeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<22: return "Good evening"
        default: return "Good evening"
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Deep green gradient background
                LinearGradient(
                    colors: [
                        Color(red: 0.08, green: 0.28, blue: 0.08),
                        Color(red: 0.05, green: 0.18, blue: 0.05)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                // Subtle dot texture overlay
                Canvas { context, size in
                    for row in stride(from: 0, to: size.height, by: 18) {
                        for col in stride(from: 0, to: size.width, by: 18) {
                            let rect = CGRect(x: col, y: row, width: 1.5, height: 1.5)
                            context.fill(Path(ellipseIn: rect), with: .color(.white.opacity(0.04)))
                        }
                    }
                }
                .ignoresSafeArea()

                // Grass along the bottom of the screen
                GeometryReader { geo in
                    BackgroundGrass(width: geo.size.width, height: geo.size.height)
                }
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {

                        // Header
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(greeting())
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.white.opacity(0.6))
                                Text("Lawnmower")
                                    .font(.system(size: 36, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            ZStack {
                                Circle()
                                    .fill(.white.opacity(0.12))
                                    .frame(width: 52, height: 52)
                                Image(systemName: "leaf.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)

                        // Cards grid
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 14),
                            GridItem(.flexible(), spacing: 14)
                        ], spacing: 14) {
                            MenuCard(
                                title: "Tasks",
                                subtitle: "Schedule & to-dos",
                                icon: "checklist",
                                accentColor: Color(red: 0.25, green: 0.78, blue: 0.35),
                                destination: PlaceholderView(title: "Tasks")
                            )
                            MenuCard(
                                title: "Lawn Map",
                                subtitle: "Your property zones",
                                icon: "map.fill",
                                accentColor: Color(red: 0.35, green: 0.65, blue: 0.95),
                                destination: PlaceholderView(title: "Lawn Map")
                            )
                            MenuCard(
                                title: "Rainfall",
                                subtitle: "Last 7 days",
                                icon: "cloud.rain.fill",
                                accentColor: Color(red: 0.45, green: 0.75, blue: 1.0),
                                destination: RainfallView()
                            )
                            MenuCard(
                                title: "Settings",
                                subtitle: "App preferences",
                                icon: "gearshape.fill",
                                accentColor: Color(red: 0.75, green: 0.75, blue: 0.80),
                                destination: SettingsView()
                            )
                            
                        }
                        .padding(.horizontal, 20)

                        // Quick status card
                        VStack(alignment: .leading, spacing: 14) {
                            HStack {
                                Text("Quick Status")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.5))
                                    .textCase(.uppercase)
                                    .kerning(0.8)
                                Spacer()
                            }

                            HStack(spacing: 12) {
                                StatusPill(
                                    icon: "lawnmower.fill",
                                    label: "Last Mowed",
                                    value: "3 days ago",
                                    color: Color(red: 0.25, green: 0.78, blue: 0.35)
                                )
                                Rectangle()
                                    .fill(.white.opacity(0.1))
                                    .frame(width: 1, height: 36)
                                StatusPill(
                                    icon: "drop.fill",
                                    label: "Last Watered",
                                    value: "Yesterday",
                                    color: Color(red: 0.45, green: 0.75, blue: 1.0)
                                )
                            }
                        }
                        .padding(18)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.white.opacity(0.08))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .strokeBorder(.white.opacity(0.12), lineWidth: 1)
                                )
                        )
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 160)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Background Grass
struct BackgroundGrass: View {
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        Canvas { context, size in
            struct Blade {
                let x: CGFloat
                let bladeHeight: CGFloat
                let curve: CGFloat
                let bladeWidth: CGFloat
                let opacity: Double
            }

            // Generate dense grass across full width at bottom
            let blades: [Blade] = [
                // Back row - tallest, most transparent
                Blade(x: width * 0.00, bladeHeight: 140, curve: -14, bladeWidth: 10, opacity: 0.12),
                Blade(x: width * 0.04, bladeHeight: 160, curve: 12, bladeWidth: 11, opacity: 0.10),
                Blade(x: width * 0.08, bladeHeight: 130, curve: -10, bladeWidth: 9,  opacity: 0.13),
                Blade(x: width * 0.12, bladeHeight: 150, curve: 15, bladeWidth: 10, opacity: 0.11),
                Blade(x: width * 0.16, bladeHeight: 145, curve: -12, bladeWidth: 11, opacity: 0.12),
                Blade(x: width * 0.20, bladeHeight: 155, curve: 10, bladeWidth: 9,  opacity: 0.10),
                Blade(x: width * 0.24, bladeHeight: 135, curve: -15, bladeWidth: 10, opacity: 0.13),
                Blade(x: width * 0.28, bladeHeight: 160, curve: 12, bladeWidth: 11, opacity: 0.11),
                Blade(x: width * 0.32, bladeHeight: 140, curve: -10, bladeWidth: 9,  opacity: 0.12),
                Blade(x: width * 0.36, bladeHeight: 150, curve: 14, bladeWidth: 10, opacity: 0.10),
                Blade(x: width * 0.40, bladeHeight: 145, curve: -12, bladeWidth: 11, opacity: 0.13),
                Blade(x: width * 0.44, bladeHeight: 155, curve: 11, bladeWidth: 9,  opacity: 0.11),
                Blade(x: width * 0.48, bladeHeight: 135, curve: -14, bladeWidth: 10, opacity: 0.12),
                Blade(x: width * 0.52, bladeHeight: 160, curve: 12, bladeWidth: 11, opacity: 0.10),
                Blade(x: width * 0.56, bladeHeight: 140, curve: -10, bladeWidth: 9,  opacity: 0.13),
                Blade(x: width * 0.60, bladeHeight: 150, curve: 15, bladeWidth: 10, opacity: 0.11),
                Blade(x: width * 0.64, bladeHeight: 145, curve: -12, bladeWidth: 11, opacity: 0.12),
                Blade(x: width * 0.68, bladeHeight: 155, curve: 10, bladeWidth: 9,  opacity: 0.10),
                Blade(x: width * 0.72, bladeHeight: 135, curve: -15, bladeWidth: 10, opacity: 0.13),
                Blade(x: width * 0.76, bladeHeight: 160, curve: 12, bladeWidth: 11, opacity: 0.11),
                Blade(x: width * 0.80, bladeHeight: 140, curve: -10, bladeWidth: 9,  opacity: 0.12),
                Blade(x: width * 0.84, bladeHeight: 150, curve: 14, bladeWidth: 10, opacity: 0.10),
                Blade(x: width * 0.88, bladeHeight: 145, curve: -12, bladeWidth: 11, opacity: 0.13),
                Blade(x: width * 0.92, bladeHeight: 155, curve: 11, bladeWidth: 9,  opacity: 0.11),
                Blade(x: width * 0.96, bladeHeight: 135, curve: -14, bladeWidth: 10, opacity: 0.12),

                // Middle row - medium height
                Blade(x: width * 0.02, bladeHeight: 100, curve: 10, bladeWidth: 12, opacity: 0.18),
                Blade(x: width * 0.07, bladeHeight: 115, curve: -13, bladeWidth: 13, opacity: 0.20),
                Blade(x: width * 0.13, bladeHeight: 105, curve: 11, bladeWidth: 12, opacity: 0.18),
                Blade(x: width * 0.19, bladeHeight: 120, curve: -10, bladeWidth: 13, opacity: 0.20),
                Blade(x: width * 0.25, bladeHeight: 100, curve: 14, bladeWidth: 12, opacity: 0.18),
                Blade(x: width * 0.31, bladeHeight: 110, curve: -12, bladeWidth: 13, opacity: 0.20),
                Blade(x: width * 0.37, bladeHeight: 105, curve: 10, bladeWidth: 12, opacity: 0.18),
                Blade(x: width * 0.43, bladeHeight: 120, curve: -13, bladeWidth: 13, opacity: 0.20),
                Blade(x: width * 0.49, bladeHeight: 100, curve: 11, bladeWidth: 12, opacity: 0.18),
                Blade(x: width * 0.55, bladeHeight: 115, curve: -10, bladeWidth: 13, opacity: 0.20),
                Blade(x: width * 0.61, bladeHeight: 105, curve: 14, bladeWidth: 12, opacity: 0.18),
                Blade(x: width * 0.67, bladeHeight: 120, curve: -12, bladeWidth: 13, opacity: 0.20),
                Blade(x: width * 0.73, bladeHeight: 100, curve: 10, bladeWidth: 12, opacity: 0.18),
                Blade(x: width * 0.79, bladeHeight: 110, curve: -13, bladeWidth: 13, opacity: 0.20),
                Blade(x: width * 0.85, bladeHeight: 105, curve: 11, bladeWidth: 12, opacity: 0.18),
                Blade(x: width * 0.91, bladeHeight: 120, curve: -10, bladeWidth: 13, opacity: 0.20),
                Blade(x: width * 0.97, bladeHeight: 100, curve: 14, bladeWidth: 12, opacity: 0.18),

                // Front row - shortest, most opaque
                Blade(x: width * 0.01, bladeHeight: 70, curve: -8,  bladeWidth: 14, opacity: 0.28),
                Blade(x: width * 0.06, bladeHeight: 80, curve: 11,  bladeWidth: 15, opacity: 0.30),
                Blade(x: width * 0.12, bladeHeight: 72, curve: -10, bladeWidth: 14, opacity: 0.28),
                Blade(x: width * 0.18, bladeHeight: 85, curve: 8,   bladeWidth: 15, opacity: 0.30),
                Blade(x: width * 0.24, bladeHeight: 70, curve: -12, bladeWidth: 14, opacity: 0.28),
                Blade(x: width * 0.30, bladeHeight: 78, curve: 10,  bladeWidth: 15, opacity: 0.30),
                Blade(x: width * 0.36, bladeHeight: 72, curve: -8,  bladeWidth: 14, opacity: 0.28),
                Blade(x: width * 0.42, bladeHeight: 85, curve: 11,  bladeWidth: 15, opacity: 0.30),
                Blade(x: width * 0.48, bladeHeight: 70, curve: -10, bladeWidth: 14, opacity: 0.28),
                Blade(x: width * 0.54, bladeHeight: 80, curve: 8,   bladeWidth: 15, opacity: 0.30),
                Blade(x: width * 0.60, bladeHeight: 72, curve: -12, bladeWidth: 14, opacity: 0.28),
                Blade(x: width * 0.66, bladeHeight: 85, curve: 10,  bladeWidth: 15, opacity: 0.30),
                Blade(x: width * 0.72, bladeHeight: 70, curve: -8,  bladeWidth: 14, opacity: 0.28),
                Blade(x: width * 0.78, bladeHeight: 78, curve: 11,  bladeWidth: 15, opacity: 0.30),
                Blade(x: width * 0.84, bladeHeight: 72, curve: -10, bladeWidth: 14, opacity: 0.28),
                Blade(x: width * 0.90, bladeHeight: 85, curve: 8,   bladeWidth: 15, opacity: 0.30),
                Blade(x: width * 0.96, bladeHeight: 70, curve: -12, bladeWidth: 14, opacity: 0.28),
            ]

            for blade in blades {
                var path = Path()
                let baseY = size.height
                let tipX = blade.x + blade.curve
                let tipY = size.height - blade.bladeHeight
                let ctrlX = blade.x + blade.curve * 0.7
                let ctrlY = size.height - blade.bladeHeight * 0.5
                let rightBaseX = blade.x + blade.bladeWidth
                let rightTipX = tipX + blade.bladeWidth * 0.4
                let rightCtrlX = ctrlX + blade.bladeWidth * 0.4

                path.move(to: CGPoint(x: blade.x, y: baseY))
                path.addQuadCurve(
                    to: CGPoint(x: tipX, y: tipY),
                    control: CGPoint(x: ctrlX, y: ctrlY)
                )
                path.addLine(to: CGPoint(x: rightTipX, y: tipY))
                path.addQuadCurve(
                    to: CGPoint(x: rightBaseX, y: baseY),
                    control: CGPoint(x: rightCtrlX, y: ctrlY)
                )
                path.closeSubpath()
                context.fill(path, with: .color(.white.opacity(blade.opacity)))
            }
        }
    }
}

// MARK: - Menu Card
struct MenuCard<Destination: View>: View {
    let title: String
    let subtitle: String
    let icon: String
    let accentColor: Color
    let destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            ZStack(alignment: .bottomLeading) {

                // Card background
                RoundedRectangle(cornerRadius: 22)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.13, green: 0.38, blue: 0.13),
                                Color(red: 0.08, green: 0.25, blue: 0.08)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                // Glass border
                RoundedRectangle(cornerRadius: 22)
                    .strokeBorder(
                        LinearGradient(
                            colors: [.white.opacity(0.18), .white.opacity(0.04)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )

                // Content
                VStack(alignment: .leading, spacing: 10) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(accentColor.opacity(0.18))
                            .frame(width: 46, height: 46)
                        Image(systemName: icon)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(accentColor)
                    }

                    Spacer()

                    VStack(alignment: .leading, spacing: 3) {
                        Text(title)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                        Text(subtitle)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.white.opacity(0.5))
                            .lineLimit(1)
                    }
                }
                .padding(16)
            }
            .frame(height: 150)
        }
        .buttonStyle(CardButtonStyle())
    }
}

// MARK: - Card Button Style
struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Status Pill
struct StatusPill: View {
    let icon: String
    let label: String
    let value: String
    let color: Color

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 16))
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.45))
                Text(value)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Placeholder
struct PlaceholderView: View {
    let title: String

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.08, green: 0.28, blue: 0.08),
                    Color(red: 0.05, green: 0.18, blue: 0.05)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 12) {
                Image(systemName: "hammer.fill")
                    .font(.system(size: 48))
                    .foregroundColor(.white.opacity(0.3))
                Text(title)
                    .font(.title2.bold())
                    .foregroundColor(.white)
                Text("Coming soon")
                    .foregroundColor(.white.opacity(0.4))
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

#Preview {
    ContentView()
}
