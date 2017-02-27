//
//  User+Image.swift
//  CelebrityKey
//
//  Created by Ondrej Rafaj on 26/12/2016.
//  Copyright © 2016 CelebrityKey. All rights reserved.
//

import Foundation
import Vapor
import S3
import MongoMD5


extension User {
    
    
    // MARK: Gravatar
    
    var gravatarUrl: URL? {
        get {
            guard let email: String = self.email else {
                return nil
            }
            let url: URL? = URL(string: "https://www.gravatar.com/avatar/" + email.lowercased().md5)
            return url
        }
    }
    
    func gravatarUrl(size: UInt) -> URL? {
        guard var url: URL = self.gravatarUrl else {
            return nil
        }
        url.appendPathComponent("?s=" + String(size))
        return url
    }
    
    // MARK: Custom profile picture
    
    
    
}
