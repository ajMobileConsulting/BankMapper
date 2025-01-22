//
//  BankDataModel.swift
//  BankMapper
//
//  Created by Alexander Jackson on 1/21/25.
//

import Foundation

struct BankModel: Decodable {
    let data: [BankDataModel]
}

struct BankDataModel: Decodable, Identifiable {
    var id = UUID()
    let usRouting: String
    let revisionDate: String
    let newRouting: BoolOrString
    let bankData: BankData
    
    enum CodingKeys: String, CodingKey {
        case usRouting = "us_routing"
        case revisionDate = "revision_date"
        case newRouting = "new_routing"
        case bankData = "bank_data"
    }
}

struct BankData: Decodable{ //}, Identifiable {
//    var id: UUID { UUID() }
    let name: String
    let zip: String
    let city: String
    let address: String
    let state: String
    let phone: String
}

enum BoolOrString: Decodable {
    case bool(Bool)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let boolValue = try? container.decode(Bool.self) {
            self = .bool(boolValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else {
            throw DecodingError.typeMismatch(
                BoolOrString.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Value is not a Bool or String"
                )
            )
        }
    }
}
