//
//  Me.swift
//  Smoke
//
//  Created by Ondrej Rafaj on 28/11/2016.
//  Copyright © 2016 manGoweb UK Ltd. All rights reserved.
//

import Foundation


enum ErrorReason {
    
    case databaseError
    case cacheNotAccessible
    case noFile
    case noData
    case generic(String)

}


class SmokeError: Error {
    
    let type: ErrorReason
    let number: Int32
    
    
    // MARK: Initialization
    
    init(_ type: ErrorReason) {
        self.type = type
        self.number = errno
    }
    
    init(message: String) {
        self.type = .generic(message)
        self.number = -1
    }
    
}
