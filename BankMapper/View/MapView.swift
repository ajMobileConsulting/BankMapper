//
//  ContentView.swift
//  BankMapper
//
//  Created by Alexander Jackson on 1/16/25.
//

import SwiftUI
import CoreData
import MapKit

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)],
        animation: .default)
    private var users: FetchedResults<User>
    @StateObject private var viewModel = MapViewModel()

    var body: some View {
        Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.landmarks) { landmark in
                   MapAnnotation(coordinate: landmark.coordinate) {
                       VStack {
                           Image(systemName: "mappin.circle.fill")
                               .foregroundColor(.blue)
                               .font(.title)
                           Text(landmark.name)
                               .font(.caption)
                               .padding(4)
                               .background(Color.white.opacity(0.7))
                               .cornerRadius(8)
                       }
                   }
               }
               .ignoresSafeArea(edges: .all)
               .onAppear {
                   // Additional setup if needed
                   viewModel.fetchNearbyBanks()
               }
    }

    private func addItem() {
        withAnimation {
            let newItem = User(context: viewContext)
            newItem.name = "Date()"

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { users[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
