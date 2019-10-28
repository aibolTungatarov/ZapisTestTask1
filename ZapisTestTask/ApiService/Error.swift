//
//  Error.swift
//  ZapisTestTask
//
//  Created by Aibol Tungatarov on 10/27/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import Foundation
enum ServiceError: Int, Error {
    case unauthorized = 401
    case notFound = 404
    case noInternetConnection = 1009
}
