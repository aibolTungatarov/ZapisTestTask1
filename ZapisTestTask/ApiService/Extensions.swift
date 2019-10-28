//
//  Extensions.swift
//  ZapisTestTask
//
//  Created by Aibol Tungatarov on 10/27/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import UIKit

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension UIColor {
    static let mainColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
    static let violet = UIColor(red: 124/255, green: 114/255, blue: 227/255, alpha: 1)
}
