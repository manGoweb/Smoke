//
//  String+Tools.swift
//  CelebrityKey
//
//  Created by Ondrej Rafaj on 26/12/2016.
//  Copyright © 2016 CelebrityKey. All rights reserved.
//

import Foundation
import Vapor
import Hash


extension String {
    
    var md5: String {
        get {
            do {
                let bytes: Bytes = try Hash.make(.md5, self)
                return try String.init(bytes: bytes)
            }
            catch {
                return ""
            }
        }
    }
    
}
