//
//  ContentView.swift
//  BankMapper
//
//  Created by Alexander Jackson on 1/21/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        ZStack {
            Color.white
            
            TabView {
                MapView()
                    .tabItem({
                        Label("Map", systemImage: "map.fill")
                    })
                SavedLocationsView()
                    .tabItem({
                        Label("Saved Locations", systemImage: "square.and.arrow.down")
                    })
            }
        }
        
    }
}

#Preview {
    ContentView()
}
