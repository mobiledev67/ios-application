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
import Spring
import SVGKit

class SetupEnableBiometricsViewController: UIViewController {
    
    @IBOutlet weak var viewIcon: SVGKFastImageView!
    
    @IBOutlet weak var bottomPadding: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adjustConstraintToKeyboard()
        
        let url = Bundle.main.url(forResource: "fingerprint", withExtension: "svg", subdirectory: "Vectors")
        viewIcon.image = SVGKImage(contentsOf: url)
    }
    
    override func getConstraintToAdjustToKeyboard() -> NSLayoutConstraint? {
        return bottomPadding
    }
    
    
    @IBAction func onDismissTouchID(_ sender: Any) {
        getAppDelegate().updateStoryboard()
    }
    
    @IBAction func onEnableTouchID(_ sender: Any) {
        StorageHelper.shared.setEncryptionKey(getAppDelegate().getEncryptionKey()!.base64EncodedString())
        
        if let _ = StorageHelper.shared.getEncryptionKey(prompt: "Confirm to enable TouchID") {
            StorageHelper.shared.setBiometricUnlockEnabled(true)
            getAppDelegate().updateStoryboard()
        }
    }
}
