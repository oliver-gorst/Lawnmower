//
//  SettingsView.swift
//  Lawnmower
//
//  Created by Oliver Gorst on 4/25/26.
//
import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings = AppSettings.shared

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

            GeometryReader { geo in
                BackgroundGrass(width: geo.size.width, height: geo.size.height)
            }
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {

                    VStack(alignment: .leading, spacing: 14) {
                        Text("Measurements")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white.opacity(0.5))
                            .textCase(.uppercase)
                            .kerning(0.8)
                            .padding(.horizontal, 20)

                        VStack(spacing: 0) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Use Metric Units")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white)
                                    Text(settings.useMetric ? "Showing mm" : "Showing inches")
                                        .font(.system(size: 13))
                                        .foregroundColor(.white.opacity(0.45))
                                }
                                Spacer()
                                Toggle("", isOn: $settings.useMetric)
                                    .tint(Color(red: 0.25, green: 0.78, blue: 0.35))
                            }
                            .padding(18)
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
                .padding(.top, 16)
                .padding(.bottom, 160)
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
