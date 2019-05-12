//
//  PasswordAlgorithmFormOption.swift
//  Raivo
//
//  Created by Tijme Gommers on 03/05/2019.
//  Copyright © 2019 Tijme Gommers. All rights reserved.
//

import Foundation

class PasswordAlgorithmFormOption: BaseFormOption {
    
   
    static let OPTION_SHA1 = PasswordAlgorithmFormOption("SHA1", description: "SHA1")
    static let OPTION_SHA256 = PasswordAlgorithmFormOption("SHA256", description: "SHA256")
    static let OPTION_SHA512 = PasswordAlgorithmFormOption("SHA512", description: "SHA512")
    
    static let OPTION_DEFAULT = OPTION_SHA1
    
    static let options = [
        OPTION_SHA1,
        OPTION_SHA256,
        OPTION_SHA512
    ]
    
    var value: String
    var description: String
    
    init(_ value: String, description: String) {
        self.value = value
        self.description = description
    }
    
    static func build(_ value: String) -> PasswordAlgorithmFormOption? {        
        for option in options {
            if option.value.elementsEqual(value) {
                return option
            }
        }
        
        return nil
    }
    
    static func == (lhs: PasswordAlgorithmFormOption, rhs: PasswordAlgorithmFormOption) -> Bool {
        return lhs.value == rhs.value
    }
    
}
