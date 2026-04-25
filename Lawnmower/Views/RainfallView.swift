import SwiftUI
import CoreLocation

struct RainfallView: View {
    @StateObject private var locationManager = LocationManager()
    @ObservedObject var settings = AppSettings.shared
    @State private var rainfallData: [DayRainfall] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var totalRainfallInches: Double = 0

    var displayTotal: Double {
        settings.useMetric ? totalRainfallInches / 0.0393701 : totalRainfallInches
    }

    var unitLabel: String {
        settings.useMetric ? "mm" : "in"
    }

    var formatString: String {
        settings.useMetric ? "%.1f mm" : "%.2f in"
    }

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
                VStack(spacing: 20) {

                    // Total rainfall summary card
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(.white.opacity(0.08))
                                .frame(width: 72, height: 72)
                            Image(systemName: "cloud.rain.fill")
                                .font(.system(size: 32))
                                .foregroundColor(Color(red: 0.45, green: 0.75, blue: 1.0))
                        }

                        if isLoading {
                            ProgressView()
                                .tint(.white)
                                .padding(.top, 4)
                            Text("Fetching rainfall data...")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.5))
                        } else if let error = errorMessage {
                            Text(error)
                                .font(.subheadline)
                                .foregroundColor(.red.opacity(0.8))
                                .multilineTextAlignment(.center)
                        } else {
                            Text(String(format: formatString, displayTotal))
                                .font(.system(size: 52, weight: .bold, design: .rounded))
                                .foregroundColor(.white)

                            Text(locationManager.cityName.isEmpty
                                 ? "Total rainfall in the last 7 days"
                                 : "Total rainfall in the last 7 days in \(locationManager.cityName)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.5))
                                .multilineTextAlignment(.center)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 22)
                            .fill(.white.opacity(0.08))
                            .overlay(
                                RoundedRectangle(cornerRadius: 22)
                                    .strokeBorder(.white.opacity(0.12), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 20)

                    // Daily breakdown
                    if !rainfallData.isEmpty {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Daily Breakdown")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.white.opacity(0.5))
                                .textCase(.uppercase)
                                .kerning(0.8)
                                .padding(.horizontal, 20)

                            VStack(spacing: 0) {
                                ForEach(rainfallData) { day in
                                    RainfallRow(
                                        day: day,
                                        maxRainfall: rainfallData.map { $0.rainfallInches }.max() ?? 1,
                                        formatString: formatString,
                                        useMetric: settings.useMetric
                                    )
                                    if day.id != rainfallData.last?.id {
                                        Divider()
                                            .background(.white.opacity(0.08))
                                            .padding(.horizontal, 16)
                                    }
                                }
                            }
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
                    }
                }
                .padding(.top, 16)
                .padding(.bottom, 160)
            }
        }
        .navigationTitle("Rainfall")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear {
            locationManager.requestLocation()
        }
        .onChange(of: locationManager.location) { _, newLocation in
            if let location = newLocation {
                fetchRainfall(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
            }
        }
        .onChange(of: locationManager.authorizationStatus) { _, status in
            if status == .denied || status == .restricted {
                isLoading = false
                errorMessage = "Location access denied. Please enable it in Settings to see local rainfall."
            }
        }
    }

    func fetchRainfall(lat: Double, lon: Double) {
        let calendar = Calendar.current
        let today = Date()
        let sevenDaysAgo = calendar.date(byAdding: .day, value: -6, to: today)!

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let startDate = formatter.string(from: sevenDaysAgo)
        let endDate = formatter.string(from: today)

        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&daily=precipitation_sum&timezone=auto&start_date=\(startDate)&end_date=\(endDate)"

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    isLoading = false
                    errorMessage = "Failed to fetch data: \(error.localizedDescription)"
                    return
                }

                guard let data = data else {
                    isLoading = false
                    errorMessage = "No data received."
                    return
                }

                do {
                    let decoded = try JSONDecoder().decode(OpenMeteoResponse.self, from: data)
                    let dates = decoded.daily.time
                    let rainfall = decoded.daily.precipitation_sum

                    let displayFormatter = DateFormatter()
                    displayFormatter.dateFormat = "yyyy-MM-dd"

                    let labelFormatter = DateFormatter()
                    labelFormatter.dateFormat = "EEE MMM d"

                    rainfallData = zip(dates, rainfall).map { date, rain in
                        let parsedDate = displayFormatter.date(from: date) ?? today
                        return DayRainfall(
                            date: parsedDate,
                            label: labelFormatter.string(from: parsedDate),
                            rainfallInches: (rain ?? 0) * 0.0393701
                        )
                    }

                    totalRainfallInches = rainfallData.reduce(0) { $0 + $1.rainfallInches }
                    isLoading = false
                } catch {
                    isLoading = false
                    errorMessage = "Failed to parse data."
                }
            }
        }.resume()
    }
}

// MARK: - Rainfall Row
struct RainfallRow: View {
    let day: DayRainfall
    let maxRainfall: Double
    let formatString: String
    let useMetric: Bool

    var displayRainfall: Double {
        useMetric ? day.rainfallInches / 0.0393701 : day.rainfallInches
    }

    var displayMax: Double {
        useMetric ? maxRainfall / 0.0393701 : maxRainfall
    }

    var body: some View {
        HStack(spacing: 12) {
            Text(day.label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
                .frame(width: 100, alignment: .leading)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.white.opacity(0.08))
                        .frame(height: 10)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(red: 0.45, green: 0.75, blue: 1.0))
                        .frame(
                            width: displayRainfall > 0
                                ? geo.size.width * CGFloat(displayRainfall / max(displayMax, 1))
                                : 3,
                            height: 10
                        )
                }
            }
            .frame(height: 10)

            Text(String(format: formatString, displayRainfall))
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.5))
                .frame(width: 62, alignment: .trailing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

// MARK: - Models
struct DayRainfall: Identifiable {
    let id = UUID()
    let date: Date
    let label: String
    let rainfallInches: Double
}

struct OpenMeteoResponse: Codable {
    let daily: DailyData
}

struct DailyData: Codable {
    let time: [String]
    let precipitation_sum: [Double?]
}

#Preview {
    NavigationStack {
        RainfallView()
    }
}
