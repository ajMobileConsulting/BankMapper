//
//  MapView.swift
//  BankMapper
//
//  Created by Alexander Jackson on 1/16/25.
//

import SwiftUI
import CoreData
import MapKit

struct MapView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: MapViewModel
    
    @State private var showLoginView = false
    
    init() {
        _viewModel = StateObject(wrappedValue: MapViewModel(viewContext: PersistenceController.shared.container.viewContext))
    }

    var body: some View {
        Map(coordinateRegion: $viewModel.region,
            annotationItems: viewModel.landmarks) { landmark in
                   MapAnnotation(coordinate: landmark.coordinate) {
                       VStack {
                           Image(systemName: "mappin.circle.fill")
                               .foregroundColor(.blue)
                               .font(.title)
                               .onTapGesture {
                                   DispatchQueue.main.async {
                                       showLoginView = true
                                       viewModel.saveLocation(
                                        name: landmark.name,
                                        latitude: landmark.coordinate.latitude,
                                        longitude: landmark.coordinate.longitude
                                       )
                                   }
                               }

                           Text(landmark.name)
                               .font(.caption)
                               .padding(4)
                               .background(Color.white.opacity(0.7))
                               .cornerRadius(8)
                       }
                   }
               }
               .ignoresSafeArea(edges: .top)
               .onAppear {
                   // Additional setup if needed
                   DispatchQueue.main.async {
                       viewModel.fetchNearbyBanks()
                   }
               }
               .fullScreenCover(isPresented: $showLoginView, content: {
                   LoginView() {
                       DispatchQueue.main.async {
                           showLoginView = false
                       }
                   }
               })
    }
}

#Preview {
    MapView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
