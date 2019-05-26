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
import RealmSwift
import Spring
import Valet

class SetupChoosePincodeViewController: UIViewController, PincodeDigitsProtocol {

    @IBOutlet weak var pincodeDigitsView: PincodeDigitsView!
    
    @IBOutlet weak var bottomPadding: NSLayoutConstraint!
    
    @IBOutlet weak var viewTitle: UILabel!
    
    @IBOutlet weak var viewExtra: SpringLabel!
    
    private var initialPincode: Data? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adjustConstraintToKeyboard()
        
        self.pincodeDigitsView.delegate = self
        self.showPincodeView("Choose Your PIN code", "You need it to unlock Raivo, so make sure you'll be able to remember it.", focus: false)
    }
    
    override func getConstraintToAdjustToKeyboard() -> NSLayoutConstraint? {
        return bottomPadding
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.pincodeDigitsView.focus()
    }
    
    func showPincodeView(_ title: String, _ extra: String, focus: Bool = true, flash: Bool = false) {
        self.viewTitle.text = title
        self.viewExtra.text = extra
        
        if focus {
            self.pincodeDigitsView.resetAndFocus()
        } else {
            self.pincodeDigitsView.reset()
        }
        
        if flash {
            self.viewExtra.delay = CGFloat(0.25)
            self.viewExtra.animation = "shake"
            self.viewExtra.animate()
        }
    }
    
    func onBiometricsTrigger() {
        // Not implemented
    }
    
    func onPincodeComplete(pincode: String) {

        DispatchQueue.main.async {
            let salt = StorageHelper.shared.getEncryptionPassword()!
            
            if self.initialPincode == nil {
                self.pincodeDigitsView.resetAndFocus()
                self.initialPincode = KeyDerivationHelper.derivePincode(pincode, salt)
                self.showPincodeView("Almost there!", "Confirm your PIN code to continue.")
            } else {
                if self.initialPincode == KeyDerivationHelper.derivePincode(pincode, salt) {
                    self.createDatabase(pincode, salt)
                } else {
                    self.initialPincode = nil
                    self.pincodeDigitsView.resetAndFocus()
                    self.showPincodeView("Oh oh, not similar :/", "Please start over by choosing a new PIN code.", flash: true)
                }
            }
        }
    }
    
    private func createDatabase(_ pincode: String, _ salt: String) {
        getAppDelegate().updateEncryptionKey(KeyDerivationHelper.derivePincode(pincode, salt))

        let _ = try! Realm(configuration: Realm.Configuration.defaultConfiguration)
                
        if StorageHelper.shared.canAccessSecrets() {
            performSegue(withIdentifier: "EnableBiometricsSegue", sender: nil)
        } else {
            getAppDelegate().updateStoryboard()
        }
    }
    
}
