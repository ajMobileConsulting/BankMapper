//
//  BankLocationsViewModel.swift
//  BankMapper
//
//  Created by Alexander Jackson on 1/21/25.
//

import Foundation

class BankLocationsViewModel: ObservableObject {
    @Published var banks: [BankDataModel] = []
    private let serviceManager: NetworkAction
    
    
    init(serviceManager: NetworkAction = NetworkManager()) {
        self.serviceManager = serviceManager
    }
    
    func fetchBanks() {
        serviceManager.get(apiURL: Endpoints.baseUrl, completion: { result in
            switch result {
            case .success(let success):
                do {
                    let banks = try JSONDecoder().decode(BankModel.self, from: success)
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        self.banks = banks.data
                    }
                    print(self.banks)
                } catch {
                    print(error)
                }
            case .failure(let failure):
                print(failure)
            }
            
        })
    }
}
