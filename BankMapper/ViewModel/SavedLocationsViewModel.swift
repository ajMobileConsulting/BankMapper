//
//  SavedLocationsViewModel.swift
//  BankMapper
//
//  Created by Alexander Jackson on 1/21/25.
//

import SwiftUI
import CoreData
import Combine

class SavedLocationsViewModel: ObservableObject {
    @Published var locations: [Location] = [] // Holds the fetched locations
    private let context: NSManagedObjectContext
    private var cancellables = Set<AnyCancellable>()

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchLocations() // Load locations when the ViewModel is initialized
        
        // Listen for Core Data changes
           NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave, object: context)
               .sink { [weak self] _ in
                   self?.fetchLocations() // Reload locations on save
               }
               .store(in: &cancellables)
    }

    // MARK: - Fetch Locations
    func fetchLocations() {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Location.name, ascending: true)]

        do {
            locations = try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch locations: \(error.localizedDescription)")
        }
    }

    // MARK: - Add Location
    func addLocation(name: String, latitude: Double, longitude: Double) {
        let newLocation = Location(context: context)
        newLocation.name = name
        newLocation.latitude = latitude
        newLocation.longitude = longitude

        saveContext()
        fetchLocations() // Refresh after adding
    }

    // MARK: - Delete Location
    func deleteLocation(at offsets: IndexSet) {
        offsets.forEach { index in
            let location = locations[index]
            context.delete(location)
        }

        saveContext()
        fetchLocations() // Refresh after deleting
    }

    // MARK: - Save Context
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}
