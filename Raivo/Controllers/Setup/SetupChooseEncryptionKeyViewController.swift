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

class SetupChooseEncryptionKeyViewController: UIViewController, UITextFieldDelegate {
    
    public var account: SyncerAccount?
    
    public var challenge: SyncerChallenge?
    
    @IBOutlet weak var bottomPadding: NSLayoutConstraint!
    
    @IBOutlet weak var viewTitle: UILabel!
    
    @IBOutlet weak var viewExtra: SpringLabel!
    
    @IBOutlet weak var viewEncryptionPassword: UITextField!
    
    @IBOutlet weak var forgotView: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewEncryptionPassword.delegate = self
        adjustConstraintToKeyboard()
        
        if let _ = self.challenge?.challenge {
            self.viewTitle.text = "Remember that encryption key?"
            self.viewExtra.text = "You've used Raivo before. Enter the encryption key you took note of back then."
            self.forgotView.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewEncryptionPassword.becomeFirstResponder()
    }
    
    override func getConstraintToAdjustToKeyboard() -> NSLayoutConstraint? {
        return bottomPadding
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onContinue(textField)
        return true
    }
    
    private func verifyChallenge() -> Bool {
        if let challenge = self.challenge?.challenge {
            do {
                let _ = try EncryptionHelper.decrypt(challenge, withKey: viewEncryptionPassword.text ?? "")
                return true
            } catch {
                return false
            }
        }
        
        return true
    }
    
    @IBAction func onContinue(_ sender: Any) {
        guard viewEncryptionPassword.text?.length ?? 0 >= 8 else {
            self.viewExtra.text = "Your encryption key must consist of 8 characters or more."
            self.viewExtra.animation = "shake"
            self.viewExtra.animate()
            return
        }
        
        guard verifyChallenge() else {
            self.viewExtra.text = "Could not decrypt the challenge based on the given encryption key."
            self.viewExtra.animation = "shake"
            self.viewExtra.animate()
            return
        }
        
        StorageHelper.shared.setEncryptionPassword(viewEncryptionPassword.text!)
        
        performSegue(withIdentifier: "ChoosePincodeSegue", sender: sender)
    }
}
