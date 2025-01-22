//
//  BankLocationsListView.swift
//  BankMapper
//
//  Created by Alexander Jackson on 1/21/25.
//

import Foundation
import SwiftUI

struct BankLocationsListView: View {
    @StateObject private var viewModel = BankLocationsViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.banks) { bank in
                VStack(alignment: .leading) {
                    Text(bank.bankData.name)
                    Text(bank.bankData.address)
                    Text("\(bank.bankData.city), \(bank.bankData.state) \(bank.bankData.zip)")
                    Text(bank.bankData.phone)
                }
                .padding(.vertical, 4)
                
            }
            .navigationTitle("Miscellaneous Bank Locations")
            .onAppear {
                viewModel.fetchBanks()
            }
        }
    }
}

