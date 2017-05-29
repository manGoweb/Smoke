//
//  String+Tools.swift
//  CelebrityKey
//
//  Created by Ondrej Rafaj on 26/12/2016.
//  Copyright © 2016 CelebrityKey. All rights reserved.
//

import Foundation
import Vapor


extension String {
    
    var md5: String {
        get {
            do {
                let bytes: Bytes = try drop.hash.make(.md5, self)
                return try String.init(bytes: bytes)
            }
            catch {
                return ""
            }
        }
    }
    
}
