//
// Raivo OTP
//
// Copyright (c) 2021 Tijme Gommers. All rights reserved. Raivo OTP
// is provided 'as-is', without any express or implied warranty.
//
// Modification, duplication or distribution of this software (in
// source and binary forms) for any purpose is strictly prohibited.
//
// https://github.com/raivo-otp/ios-application/blob/master/LICENSE.md
//

import RealmSwift
import OneTimePassword

/// A receiver object is e.g. a Macbook that can receive an encrypted One-Time-Password
class Receiver: Object, Identifiable {
    
    public static let TABLE = "Receiver"
        
    @objc dynamic var id = Int64(0)
    
    @objc dynamic var pushToken = ""
    
    @objc dynamic var name = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    public func getNewPrimaryKey() -> Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    public func getExportFields() -> [String: String] {
        return [
            "pushToken": pushToken,
            "name": name
        ]
    }

}
