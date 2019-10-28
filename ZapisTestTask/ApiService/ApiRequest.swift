//
//  ApiRequest.swift
//  ZapisTestTask
//
//  Created by Aibol Tungatarov on 10/26/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import Foundation
public enum RequestType: String {
    case GET, POST, DELETE, PATCH
}
protocol ApiRequest {
    var method: RequestType { get }
    var path: String { get }
    var parameters: [String: String] { get }
}

