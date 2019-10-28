//
//  Banner.swift
//  ZapisTestTask
//
//  Created by Aibol Tungatarov on 10/27/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import Foundation

struct Banners: Decodable {
    var banners: [Banner]?
}

struct Banner: Decodable {
    var pictureUrl: String?
}
