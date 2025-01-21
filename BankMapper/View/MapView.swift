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
    
    @State private var showListView = false
    
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
                                   showListView = true
                                   viewModel.saveLocation(
                                    name: landmark.name,
                                    latitude: landmark.coordinate.latitude,
                                    longitude: landmark.coordinate.longitude
                                   )
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
                   viewModel.fetchNearbyBanks()
               }

               .fullScreenCover(isPresented: $showListView, content: {
                   ListView() {
                       showListView = false
                   }
               })
    }
}


struct ListView: View {
    let dismissAction: () -> ()
    
    var body: some View {
        NavigationView {
            Color.cyan
                .ignoresSafeArea(edges: .all)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Back") {
                            dismissAction()
                        }
                    }
                }
        }
    }
}

#Preview {
    MapView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
