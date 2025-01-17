//
//  BankMapperApp.swift
//  BankMapper
//
//  Created by Alexander Jackson on 1/16/25.
//

import SwiftUI

@main
struct BankMapperApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
