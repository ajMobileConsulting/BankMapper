//
//  ContentView.swift
//  BankMapper
//
//  Created by Alexander Jackson on 1/21/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    private var network: NetworkAction = NetworkManager()
    var body: some View {
        
        ZStack {
            Color.white
            
            TabView {
                MapView()
                    .tabItem({
                        Label("Map", systemImage: "map.fill")
                    })
                SavedLocationsView(context: viewContext)
                    .tabItem({
                        Label("Saved Locations", systemImage: "square.and.arrow.down")
                    })
                BankLocationsListView()
                    .tabItem({
                        Label("Miscellaneous Banks", systemImage: "dollarsign.bank.building.fill")
                    })
            }
        }
        
    }
}

#Preview {
    ContentView()
}
