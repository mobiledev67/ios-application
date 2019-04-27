//
//  BaseClass.swift
//  Raivo
//
//  Created by Tijme Gommers on 19/04/2019.
//  Copyright © 2019 Tijme Gommers. All rights reserved.
//

import Foundation
import RealmSwift

class BaseClass {
    
    public static var UNIQUE_ID: String {
        return AppHelper.identifier + String(describing: self).split(separator: ".").last!
    }
    
    public var UNIQUE_ID: String {
        return AppHelper.identifier + String(describing: self).split(separator: ".").last!
    }
    
}

extension Object {
    
    public static var UNIQUE_ID: String {
        return AppHelper.identifier + String(describing: self).split(separator: ".").last!
    }
    
    public var UNIQUE_ID: String {
        return AppHelper.identifier + String(describing: self).split(separator: ".").last!
    }
    
}
