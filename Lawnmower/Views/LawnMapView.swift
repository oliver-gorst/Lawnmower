import SwiftUI
import MapKit

// MARK: - Sprinkler Model
struct Sprinkler: Identifiable, Codable {
    let id: UUID
    var latitude: Double
    var longitude: Double
    var name: String

    init(id: UUID = UUID(), latitude: Double, longitude: Double, name: String) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
    }
}

// MARK: - LawnMapView
struct LawnMapView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var sprinklers: [Sprinkler] = []
    @State private var selectedSprinkler: Sprinkler?
    @State private var isAddingMode = false
    @State private var showDeleteAlert = false
    @State private var sprinklerToDelete: Sprinkler?
    @State private var mapPosition: MapCameraPosition = .userLocation(
        followsHeading: false,
        fallback: .automatic
    )

    var body: some View {
        ZStack(alignment: .bottom) {

            // Map
            MapReader { proxy in
                Map(position: $mapPosition) {
                    UserAnnotation()

                    ForEach(sprinklers) { sprinkler in
                        Annotation(sprinkler.name, coordinate: CLLocationCoordinate2D(
                            latitude: sprinkler.latitude,
                            longitude: sprinkler.longitude
                        )) {
                            SprinklerPin(
                                isSelected: selectedSprinkler?.id == sprinkler.id
                            )
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3)) {
                                    if selectedSprinkler?.id == sprinkler.id {
                                        selectedSprinkler = nil
                                    } else {
                                        selectedSprinkler = sprinkler
                                    }
                                }
                            }
                        }
                    }
                }
                .mapStyle(.hybrid(elevation: .realistic))
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                    MapScaleView()
                }
                .onTapGesture { screenPoint in
                    guard isAddingMode else { return }
                    if let coordinate = proxy.convert(screenPoint, from: .local) {
                        let count = sprinklers.count + 1
                        let newSprinkler = Sprinkler(
                            latitude: coordinate.latitude,
                            longitude: coordinate.longitude,
                            name: "Sprinkler \(count)"
                        )
                        withAnimation {
                            sprinklers.append(newSprinkler)
                        }
                        saveSprinklers()
                        isAddingMode = false
                    }
                }
            }

            // Bottom controls
            VStack(spacing: 12) {

                // Selected sprinkler card
                if let selected = selectedSprinkler {
                    HStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(Color(red: 0.35, green: 0.65, blue: 0.95).opacity(0.2))
                                .frame(width: 44, height: 44)
                            Image(systemName: "drop.fill")
                                .foregroundColor(Color(red: 0.35, green: 0.65, blue: 0.95))
                                .font(.system(size: 18))
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(selected.name)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            Text(String(format: "%.6f, %.6f", selected.latitude, selected.longitude))
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.45))
                        }

                        Spacer()

                        Button {
                            sprinklerToDelete = selected
                            showDeleteAlert = true
                        } label: {
                            Image(systemName: "trash.fill")
                                .foregroundColor(.red.opacity(0.8))
                                .font(.system(size: 16))
                                .padding(10)
                                .background(Circle().fill(.white.opacity(0.08)))
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .strokeBorder(.white.opacity(0.12), lineWidth: 1)
                            )
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                // Add sprinkler button
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        isAddingMode.toggle()
                        selectedSprinkler = nil
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: isAddingMode ? "xmark.circle.fill" : "plus.circle.fill")
                            .font(.system(size: 18))
                        Text(isAddingMode ? "Cancel" : "Add Sprinkler")
                            .font(.system(size: 15, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(isAddingMode
                                  ? Color.red.opacity(0.7)
                                  : Color(red: 0.35, green: 0.65, blue: 0.95).opacity(0.85))
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
        .navigationTitle("Lawn Map")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .overlay(
            Group {
                if isAddingMode {
                    VStack {
                        HStack(spacing: 8) {
                            Image(systemName: "hand.tap.fill")
                                .font(.system(size: 14))
                            Text("Tap anywhere on the map to place a sprinkler")
                                .font(.system(size: 14, weight: .medium))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(Color(red: 0.35, green: 0.65, blue: 0.95).opacity(0.9))
                        )
                        .padding(.top, 12)
                        Spacer()
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
        )
        .alert("Delete Sprinkler", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let toDelete = sprinklerToDelete {
                    withAnimation {
                        sprinklers.removeAll { $0.id == toDelete.id }
                        selectedSprinkler = nil
                    }
                    saveSprinklers()
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to remove \(sprinklerToDelete?.name ?? "this sprinkler")?")
        }
        .onAppear {
            locationManager.requestLocation()
            loadSprinklers()
            zoomToLocation()
        }
        .onChange(of: locationManager.location) { _, newLocation in
            guard let location = newLocation else { return }
            withAnimation {
                mapPosition = .region(MKCoordinateRegion(
                    center: location.coordinate,
                    latitudinalMeters: 150,
                    longitudinalMeters: 150
                ))
            }
        }
    }

    func zoomToLocation() {
        if let location = locationManager.location {
            mapPosition = .region(MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: 150,
                longitudinalMeters: 150
            ))
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                if let location = locationManager.location {
                    withAnimation {
                        mapPosition = .region(MKCoordinateRegion(
                            center: location.coordinate,
                            latitudinalMeters: 150,
                            longitudinalMeters: 150
                        ))
                    }
                }
            }
        }
    }

    func saveSprinklers() {
        if let encoded = try? JSONEncoder().encode(sprinklers) {
            UserDefaults.standard.set(encoded, forKey: "sprinklers")
        }
    }

    func loadSprinklers() {
        if let data = UserDefaults.standard.data(forKey: "sprinklers"),
           let decoded = try? JSONDecoder().decode([Sprinkler].self, from: data) {
            sprinklers = decoded
        }
    }
}

// MARK: - Sprinkler Pin
struct SprinklerPin: View {
    let isSelected: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(isSelected
                      ? Color(red: 0.35, green: 0.65, blue: 0.95)
                      : Color(red: 0.35, green: 0.65, blue: 0.95).opacity(0.85))
                .frame(width: isSelected ? 40 : 32, height: isSelected ? 40 : 32)
                .shadow(color: Color(red: 0.35, green: 0.65, blue: 0.95).opacity(0.5),
                        radius: isSelected ? 8 : 4)

            Image(systemName: "drop.fill")
                .font(.system(size: isSelected ? 18 : 14, weight: .semibold))
                .foregroundColor(.white)
        }
        .animation(.spring(response: 0.3), value: isSelected)
    }
}

#Preview {
    NavigationStack {
        LawnMapView()
    }
}
