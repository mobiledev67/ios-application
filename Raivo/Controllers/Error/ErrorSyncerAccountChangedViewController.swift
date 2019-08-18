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

class ErrorSyncerAccountChangedViewController: ErrorRootViewController {
    
    @IBOutlet weak var viewTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewTitle.text = "Your " + SyncerHelper.shared.getSyncer().name + " account is unavailable"
    }
    
    @IBAction func onContinue(_ sender: Any) {
        let refreshAlert = UIAlertController(
            title: "Are you sure?",
            message: "Your local Raivo data will be deleted.",
            preferredStyle: UIAlertController.Style.alert
        )
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action: UIAlertAction!) in
            StateHelper.shared.reset()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
}
