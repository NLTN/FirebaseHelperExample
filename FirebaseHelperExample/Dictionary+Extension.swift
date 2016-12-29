//
//  Dictionary+Extension.swift
//  FirebaseHelperExample
//
//  Created by Nguyen Nguyen on 12/27/16.
//  Copyright © 2016 Nguyen Nguyen. All rights reserved.
//

import Foundation

extension Dictionary {
    func toJSON() -> Any {
        do {
            // Dictionary to JSON Data
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            
            // JSON data to string
            return NSString(data: jsonData, encoding:String.Encoding.utf8.rawValue)! as String
        } catch {
            print(error.localizedDescription)
            return ""
        }
    }
}
