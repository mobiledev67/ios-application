//
//  SetupFlushDataViewController.swift
//  Raivo
//
//  Created by Tijme Gommers on 24/04/2019.
//  Copyright © 2019 Tijme Gommers. All rights reserved.
//

import Foundation
import UIKit

class SetupFlushDataViewController: UIViewController {
    
    @IBAction func confirm(_ sender: Any) {
        let popup = UIAlertController(title: "Are you sure?", message: "ALL your data will be deleted and you will NOT be able to recover it!", preferredStyle: .alert)
        
        popup.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action: UIAlertAction!) in
            self.flushData()
        }))
        
        popup.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            popup.dismiss(animated: true, completion: nil)
        }))
        
        present(popup, animated: true, completion: nil)
    }
    
    private func flushData() {
        let _ = displayNavBarActivity()
        
        SyncerHelper.shared.getSyncer().flushAllData(success: { (syncerType) in
            self.dismissNavBarActivity()
            StateHelper.shared.reset()           
        }) { (error, syncerType) in
            self.dismissNavBarActivity()
            
            let popup = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            
            popup.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                popup.dismiss(animated: true, completion: nil)
            }))
            
            self.present(popup, animated: true, completion: nil)
        }
    }
    
}
