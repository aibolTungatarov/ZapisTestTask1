//
//  Constants.swift
//  ZapisTestTask
//
//  Created by Aibol Tungatarov on 10/26/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import UIKit

public struct Constants {
    struct ProductionServer {
        static let baseURL = "http://zp.jgroup.kz/rest/v1"
        static let imageBaseURL = "http://zp.jgroup.kz"
    }
    struct YandexMapAPIParameterKey {
        static let apiKey = "f2469e79-153e-4e47-8e88-9f8dd9a09c4f"
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case apiKey = "api_key"
}

enum ContentType: String {
    case json = "application/json; charset=utf-8"
}

