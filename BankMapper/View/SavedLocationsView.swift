//
//  SavedLocationsView.swift
//  BankMapper
//
//  Created by Alexander Jackson on 1/21/25.
//

import SwiftUI
import CoreData

struct SavedLocationsView: View {
    @StateObject private var viewModel: SavedLocationsViewModel
    
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: SavedLocationsViewModel(context: context))
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.locations, id: \.self) { location in
                    VStack(alignment: .leading) {
                        Text(location.name ?? "Unknown Location")
                            .font(.headline)
                        Text("Latitude: \(location.latitude), Longitude: \(location.longitude)")
                            .font(.subheadline)
                    }
                }
                .onDelete { offsets in
                    viewModel.deleteLocation(at: offsets)
                }
            }
            .navigationTitle("Saved Locations")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }
}


#Preview {
    SavedLocationsView(context: PersistenceController.preview.container.viewContext)
}

