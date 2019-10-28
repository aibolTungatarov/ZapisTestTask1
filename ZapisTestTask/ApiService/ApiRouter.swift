//
//  ApiRouter.swift
//  ZapisTestTask
//
//  Created by Aibol Tungatarov on 10/26/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import Foundation

enum ApiRouter: ApiRequest {
    case getPopular
    case getRecommended
    case getSalonInfo(id: Int)
    case getMobileAppBanners
    var path: String {
        switch self {
        case .getRecommended:
            return "/salon/getRecommended"
        case .getPopular:
            return "/salon/getPopular"
        case .getSalonInfo:
            return "/salon/page"
        case .getMobileAppBanners:
            return "/getMobileAppBanners"
        }
    }
    
    var parameters: [String : String] {
        switch self {
        case .getRecommended, .getPopular, .getMobileAppBanners:
            return [:]
        case .getSalonInfo(let id):
            return ["id":"\(id)"]
        }
        
    }
    
    var method: RequestType {
        switch self {
        case .getSalonInfo, .getPopular, .getRecommended, .getMobileAppBanners:
            return .GET
        }
    }
    
    func asURLRequest() -> URLRequest {
        let baseUrl = URL(string: Constants.ProductionServer.baseURL)!.appendingPathComponent(path)
        guard var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false) else { fatalError("Couldn't create url components") }
        components.queryItems = parameters.map {
            URLQueryItem(name: $0, value: $1)
        }
        guard let url = components.url else { fatalError("Couldn't get url") }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}

