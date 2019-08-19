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

/// This controller allows users to setup their PIN code
class SetupPINCodeViewController: UIViewController, UIPincodeFieldDelegate, SetupState {
    
    /// If the user confirmed the password, this var will contain the confirmed password
    public var confirmation: String? = nil
    
    /// A reference to the PIN code field
    @IBOutlet weak var pincodeField: UIPincodeField!
    
    /// Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adjustViewToKeyboard()
        
        pincodeField.delegate = self
        pincodeField.layoutIfNeeded()
    }
    
    /// Notifies the view controller that its view was added to a view hierarchy.
    ///
    /// - Parameter animated: If positive, the view was added to the window using an animation.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pincodeField.becomeFirstResponder()
    }
    
    /// Called if the user finished entering the PIN code.
    ///
    /// - Parameter pincode: The  PIN code that the user entered.
    func onPincodeComplete(pincode: String) {
        onContinue()
    }
    
    /// If the PIN code changes, set the confirmation to nil.
    ///
    /// - Parameter pincode: The new (possibly incomplete) PIN code.
    func onPincodeChange(pincode: String) {
        confirmation = nil
    }
    
    func onContinue() {
        let pincode = pincodeField.current
        
        guard confirmation != nil else {
            return performSegue(withIdentifier: "SetupPINCodeConfirmationSegue", sender: nil)
        }
        
        guard pincode == confirmation else {
            confirmation = nil
            pincodeField.reset()
            pincodeField.becomeFirstResponder()
            
            return BannerHelper.error("The password and confirmation do not match", seconds: 2.0, icon: "👮")
        }

        state(self).pincode = pincode
        performSegue(withIdentifier: "SetupBiometricSegue", sender: nil)
    }
    
    /// Prepare for the setup encryption segue
    ///
    /// - Parameter segue: The segue object containing information about the view controllers involved in the segue.
    /// - Parameter sender: The object that initiated the segue.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "SetupPINCodeConfirmationSegue" {
            if let destination = segue.destination as? SetupPINCodeConfirmationViewController {
                destination.sendingController = self
            }
        }
    }
}
