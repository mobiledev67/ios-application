//
// Raivo OTP
//
// Copyright (c) 2019 Tijme Gommers. All rights reserved. Raivo OTP
// is provided 'as-is', without any express or implied warranty.
//
// This source code is licensed under the CC BY-NC 4.0 license found
// in the LICENSE.md file in the root directory of this source tree.
//

import Foundation
import UIKit

// MARK: - Extend UIColor with custom colors
extension UIColor {
    
    public static func getLabel(_ darkMode: Bool = false) -> UIColor {
        return UIColor(named: "color-label")!
    }
    
    public static func getSecondaryLabel(_ darkMode: Bool = false) -> UIColor {
        return UIColor(named: "color-secondary-label")!
    }
    
    public static func getTintRed(_ darkMode: Bool = false) -> UIColor {
        return UIColor(named: "color-tint-red")!
    }

    public static func getTintBlue(_ darkMode: Bool = false) -> UIColor {
        return UIColor(named: "color-tint-blue")!
    }

    public static func getBackgroundOpaque(_ darkMode: Bool = false) -> UIColor {
        return UIColor(named: "color-background-opaque")!
    }

    public static func getBackgroundTransparent(_ darkMode: Bool = false) -> UIColor {
        return UIColor(named: "color-background-transparent")!
    }
}
