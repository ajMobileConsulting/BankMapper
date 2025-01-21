//
//  MapViewModel.swift
//  BankMapper
//
//  Created by Alexander Jackson on 1/20/25.
//

import CoreData
import SwiftUI
import MapKit

// ViewModel to handle the map data
class MapViewModel: ObservableObject {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    @Published var landmarks: [Landmark] = [] // Holds the fetched bank locations

    private var viewContext: NSManagedObjectContext
    
    // Initialize with a Core Data context
      init(viewContext: NSManagedObjectContext) {
          self.viewContext = viewContext
      }
    
    // Function to fetch nearby banks
    func fetchNearbyBanks() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Bank" // Search for banks
        request.region = MKCoordinateRegion(
            center: region.center,
            span: region.span
        )
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let response = response, error == nil else {
                print("Error fetching banks: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Update landmarks with results
            DispatchQueue.main.async {
                self?.landmarks = response.mapItems.map { item in
                    Landmark(
                        name: item.name ?? "Unknown Bank",
                        coordinate: item.placemark.coordinate
                    )
                }
            }
        }
    }
    
    // Function to save a location to Core Data
    func saveLocation(name: String, latitude: Double, longitude: Double) {
        
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "latitude == %lf AND longitude == %lf", latitude, longitude)
        
        do {
            let existingLocations = try viewContext.fetch(fetchRequest)
            
            if existingLocations.isEmpty {
                let newLocation = Location(context: viewContext) // Assuming `Location` is the Core Data entity
                newLocation.name = name
                newLocation.latitude = latitude
                newLocation.longitude = longitude
                
                try viewContext.save()
                print("Saved location: \(name) at (\(latitude), \(longitude))")
            } else {
                print("Duplicate location: \(name) at (\(latitude), \(longitude))")
            }
        } catch {
            print("Failed to save location: \(error.localizedDescription)")
        }
    }
    
}
