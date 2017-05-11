//
//  Dictionary+Tools.swift
//  Smoke
//
//  Created by Ondrej Rafaj on 18/12/2016.
//  Copyright © 2016 manGoweb UK Ltd. All rights reserved.
//

import Foundation
import Vapor


extension Dictionary {
    
    static func get(fromPlistAtUrl url: URL, format: PropertyListSerialization.PropertyListFormat = PropertyListSerialization.PropertyListFormat.binary) throws -> [String: AnyObject]? {
        let plistData: Data = try Data.init(contentsOf: url)
        var varFormat: PropertyListSerialization.PropertyListFormat = format
        let plist: [String: AnyObject]? = try PropertyListSerialization.propertyList(from: plistData, options: [], format: &varFormat) as? [String:AnyObject]
        return plist
    }

}
