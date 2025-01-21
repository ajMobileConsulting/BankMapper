//
//  SavedLocationsView.swift
//  BankMapper
//
//  Created by Alexander Jackson on 1/21/25.
//

import SwiftUI
import CoreData

struct SavedLocationsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Location.entity(), // Use the Core Data entity
        sortDescriptors: [NSSortDescriptor(keyPath: \Location.name, ascending: true)]
    ) private var locations: FetchedResults<Location>

    var body: some View {
        NavigationView {
            List {
                ForEach(locations, id: \.self) { location in
                    VStack(alignment: .leading) {
                        Text(location.name ?? "Unknown Location")
                            .font(.headline)
                        Text("Latitude: \(location.latitude), Longitude: \(location.longitude)")
                            .font(.subheadline)
                    }
                }
                .onDelete(perform: deleteLocations)
            }
            .navigationTitle("Saved Locations")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }

    // Delete a location
    private func deleteLocations(offsets: IndexSet) {
        withAnimation {
            offsets.map { locations[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                print("Error deleting locations: \(error.localizedDescription)")
            }
        }
    }
}


#Preview {
    SavedLocationsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

