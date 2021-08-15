//
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

import Foundation
import UIKit
import SwiftUI

class MainReceiversViewController: UIHostingController<AnyView> {
    
    required init?(coder aDecoder: NSCoder) {
        let root = AnyView(MainReceiversView())
        
        super.init(coder: aDecoder, rootView: root)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}
