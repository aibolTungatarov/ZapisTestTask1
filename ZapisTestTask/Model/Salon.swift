//
//  Salon.swift
//  ZapisTestTask
//
//  Created by Aibol Tungatarov on 10/25/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import Foundation

struct Salons: Decodable {
    let salons: [Salon]?
}

struct SalonDetailed: Decodable {
    let salon: Salon?
    let location: Location?
}

struct Location: Decodable {
    let markerX: Double?
    let markerY: Double?
    let centerX: Double?
    let centerY: Double?
    let zoom: Int?
}

struct Salon: Decodable {
    let id: Int
    let name: String?
    let address: String?
    let type: String?
    let checkRating: Double?
    let pictureUrl: String?
    let pictures: [String]?
}
