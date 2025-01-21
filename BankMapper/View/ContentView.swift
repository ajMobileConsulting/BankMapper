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
            }
            .onAppear {
                let url = "https://api.apilayer.com/bank_data/all?per_page=20&page=1&country=us"
                
                network.get(apiURL: url, completion: { result in
                    switch result {
                    case .success(let data):
                        print(data)
                        do {
                            let banks = try JSONDecoder().decode(BankModel.self, from: data)
                            print(banks)
                        } catch {
                            print(error)
                        }
                        
                    case .failure(let error):
                        print(error)
                    }
                })
            }
        }
        
    }
}

#Preview {
    ContentView()
}
