//
// Raivo OTP
//
// Copyright (c) 2019 Tijme Gommers. All rights reserved. Raivo OTP
// is provided 'as-is', without any express or implied warranty.
//
// Modification, duplication or distribution of this software (in
// source and binary forms) for any purpose is strictly prohibited.
//
// https://github.com/tijme/raivo/blob/master/LICENSE.md
//

import Foundation
import UIKit

/// The last resort for users that forgot their password.
class SetupFlushDataViewController: UIViewController, SetupState {
    
    /// If a user confirms that he/she want's to flush all data, ask for confirmation one more time, then delete all data.
    ///
    /// - Parameter sender: The element that triggered this action.
    @IBAction func onConfirm(_ sender: Any) {
        let popup = UIAlertController(title: "Are you sure?", message: "ALL your data will be deleted and you will NOT be able to recover it!", preferredStyle: .alert)
        
        popup.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action: UIAlertAction!) in
            self.flushData()
        }))
        
        popup.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            popup.dismiss(animated: true, completion: nil)
        }))
        
        present(popup, animated: true, completion: nil)
    }
    
    /// If the user cancels the data flush action.
    ///
    /// - Parameter sender: The element that triggered this action.
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /// Flush all data via the storage provider
    private func flushData() {
        displayNavBarActivity()
        
        SyncerHelper.shared.getSyncer(state(presentingViewController!).syncerID!).flushAllData(success: { (syncerType) in
            self.dismissNavBarActivity()
            StateHelper.shared.reset()
        }) { (error, syncerType) in
            self.dismissNavBarActivity()
            BannerHelper.shared.error("Out of sync", error.localizedDescription, wrapper: self.view)
        }
    }
    
}
