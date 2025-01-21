//
//  LandmarkModel.swift
//  BankMapper
//
//  Created by Alexander Jackson on 1/20/25.
//

import Foundation
import MapKit

// Landmark model
struct Landmark: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}
