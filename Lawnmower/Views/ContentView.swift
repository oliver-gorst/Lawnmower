import SwiftUI
import Combine

struct ContentView: View {
    @AppStorage("lastMowedDate") private var lastMowedTimestamp: Double = 0
    @State private var timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    @State private var tick = false

    var lastMowedDate: Date? {
        lastMowedTimestamp == 0 ? nil : Date(timeIntervalSince1970: lastMowedTimestamp)
    }

    var daysSinceLabel: String {
        guard let date = lastMowedDate else { return "Never" }
        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: date, to: Date())
        let days = components.day ?? 0
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0

        if days > 0 {
            return "\(days)d \(hours)h \(minutes)m"
        } else if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }

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
                LinearGradient(
                    colors: [
                        Color(red: 0.08, green: 0.28, blue: 0.08),
                        Color(red: 0.05, green: 0.18, blue: 0.05)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                Canvas { context, size in
                    for row in stride(from: 0, to: size.height, by: 18) {
                        for col in stride(from: 0, to: size.width, by: 18) {
                            let rect = CGRect(x: col, y: row, width: 1.5, height: 1.5)
                            context.fill(Path(ellipseIn: rect), with: .color(.white.opacity(0.04)))
                        }
                    }
                }
                .ignoresSafeArea()

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
                                destination: LawnMapView()
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

                        // Last mowed card
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Last Mowed")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.white.opacity(0.5))
                                .textCase(.uppercase)
                                .kerning(0.8)

                            HStack(spacing: 12) {

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(daysSinceLabel)
                                        .font(.system(size: 28, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                    if let date = lastMowedDate {
                                        Text(date.formatted(date: .abbreviated, time: .omitted))
                                            .font(.system(size: 13))
                                            .foregroundColor(.white.opacity(0.45))
                                    } else {
                                        Text("No mow logged yet")
                                            .font(.system(size: 13))
                                            .foregroundColor(.white.opacity(0.45))
                                    }
                                }

                                Spacer()

                                Button {
                                    lastMowedTimestamp = Date().timeIntervalSince1970
                                    NotificationManager.shared.scheduleMowReminder(lastMowedTimestamp: lastMowedTimestamp)
                                } label: {
                                    HStack(spacing: 8) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 16))
                                        Text("I Mowed")
                                            .font(.system(size: 15, weight: .semibold))
                                    }
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 18)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(Color(red: 0.25, green: 0.78, blue: 0.35).opacity(0.8))
                                    )
                                }
                            }
                        }
                        .padding(18)
                        .background(
                            RoundedRectangle(cornerRadius: 22)
                                .fill(.white.opacity(0.08))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 22)
                                        .strokeBorder(.white.opacity(0.12), lineWidth: 1)
                                )
                        )
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 160)
                }
                .onReceive(timer) { _ in
                    tick.toggle()
                }
            }
            .navigationBarHidden(true)
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

                RoundedRectangle(cornerRadius: 22)
                    .strokeBorder(
                        LinearGradient(
                            colors: [.white.opacity(0.18), .white.opacity(0.04)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )

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
