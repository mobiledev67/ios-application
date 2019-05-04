//
//  MiscellaneousForm.swift
//  Raivo
//
//  Created by Tijme Gommers on 07/04/2019.
//  Copyright © 2019 Tijme Gommers. All rights reserved.
//

import Foundation
import Eureka

class MiscellaneousForm: BaseClass {
    
    private var form: Form
    
    public var synchronizationSection: Section { return form.sectionBy(tag: "synchronization")! }
    public var settingsSection: Section { return form.sectionBy(tag: "settings")! }
    public var aboutSection: Section { return form.sectionBy(tag: "about")! }
    public var legalSection: Section { return form.sectionBy(tag: "legal")! }
    public var advancedSection: Section { return form.sectionBy(tag: "advanced")! }
    
    public var accountRow: LabelRow { return form.rowBy(tag: "account") as! LabelRow }
    public var providerRow: LabelRow { return form.rowBy(tag: "provider") as! LabelRow }
    public var inactivityLockRow: PickerInlineRow<MiscellaneousInactivityLockFormOption> { return form.rowBy(tag: "inactivity_lock") as! PickerInlineRow<MiscellaneousInactivityLockFormOption> }
    public var touchIDUnlockRow: SwitchRow { return form.rowBy(tag: "touchid_unlock") as! SwitchRow }
    public var changePINCodeRow: ButtonRow { return form.rowBy(tag: "change_pin_code") as! ButtonRow }
    public var versionRow: LabelRow { return form.rowBy(tag: "version") as! LabelRow }
    public var compilationRow: LabelRow { return form.rowBy(tag: "compilation") as! LabelRow }
    public var authorRow: LabelRow { return form.rowBy(tag: "author") as! LabelRow }
    public var reportBugRow: ButtonRow { return form.rowBy(tag: "report_a_bug") as! ButtonRow }
    public var privacyPolicyRow: ButtonRow { return form.rowBy(tag: "privacy_policy") as! ButtonRow }
    public var securityPolicyRow: ButtonRow { return form.rowBy(tag: "security_policy") as! ButtonRow }
    public var licenseRow: ButtonRow { return form.rowBy(tag: "license") as! ButtonRow }
    public var signOutRow: ButtonRow { return form.rowBy(tag: "sign_out") as! ButtonRow }
    
    init(_ form: Form) {
        self.form = form
    }
    
    public func build(controller: UIViewController) -> Self {
        buildSynchronizationSection(controller)
        buildSettingsSection(controller)
        buildAboutSection(controller)
        buildLegalSection(controller)
        buildAdvancedSection(controller)
        
        return self
    }
    
    public func inputIsValid() -> Bool {
        form.validate()
        
        for row in form.allRows.filter({ !$0.isHidden}) {
            if !row.isValid {
                row.baseCell.cellBecomeFirstResponder()
                row.select(animated: true, scrollPosition: .top)
                return false
            }
        }
        
        return true
    }
    
    private func buildSynchronizationSection(_ controller: UIViewController) {
        let authenticated = StateHelper.getCurrentStoryboard() == StateHelper.Storyboard.MAIN
        
        form +++ Section("Synchronization", { section in
            section.tag = "synchronization"
            section.hidden = Condition(booleanLiteral: !authenticated)
            section.footer = HeaderFooterView(title: SyncerHelper.getSyncer().help)
       })
            
            <<< LabelRow("account", { row in
                row.title = "Account"
                row.value = "Loading..."
            }).cellUpdate({ cell, row in
                cell.imageView?.image = UIImage(named: "form-account")
            })
            
            <<< LabelRow("provider", { row in
                row.title = "Provider"
                row.value = "Loading..."
            }).cellUpdate({ cell, row in
                cell.imageView?.image = UIImage(named: "form-sync")
            })
    }
    
    private func buildSettingsSection(_ controller: UIViewController) {
        let authenticated = StateHelper.getCurrentStoryboard() == StateHelper.Storyboard.MAIN
        
        form +++ Section("Settings", { section in
            section.tag = "settings"
            section.hidden = Condition(booleanLiteral: !authenticated)
        })
            
            <<< PickerInlineRow<MiscellaneousInactivityLockFormOption>("inactivity_lock", { row in
                row.title = "Inactivity lock"
                row.options = MiscellaneousInactivityLockFormOption.options
                row.value = MiscellaneousInactivityLockFormOption.OPTION_DEFAULT
            }).cellUpdate({ cell, row in
                cell.textLabel?.textColor = ColorHelper.getTint()
                cell.imageView?.image = UIImage(named: "form-lock")
            }).onChange({ row in
                StorageHelper.setLockscreenTimeout(row.value!.value)
                (MyApplication.shared as! MyApplication).scheduleInactivityTimer()
                row.collapseInlineRow()
            })
            
            <<< SwitchRow("touchid_unlock", { row in
                row.title = "TouchID unlock"
                row.hidden = Condition(booleanLiteral: !StorageHelper.canAccessSecrets())
                row.value = StorageHelper.getBiometricUnlockEnabled()
            }).cellUpdate({ cell, row in
                cell.textLabel?.textColor = ColorHelper.getTint()
                cell.imageView?.image = UIImage(named: "form-biometric")
                cell.switchControl.tintColor = ColorHelper.getTint()
                cell.switchControl.onTintColor = ColorHelper.getTint()
            }).onChange({ row in
                guard let key = self.getAppDelagate().getEncryptionKey() else {
                    return
                }
                
                // Bugfix for invalid SwitchRow background if TouchID was cancelled
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if !(row.value ?? false) {
                        StorageHelper.setEncryptionKey(nil)
                        StorageHelper.setBiometricUnlockEnabled(false)
                    } else {
                        StorageHelper.setEncryptionKey(key.base64EncodedString())
                        
                        if let key = StorageHelper.getEncryptionKey(prompt: "Confirm to enable TouchID") {
                            StorageHelper.setBiometricUnlockEnabled(true)
                        } else {
                            row.value = false
                            row.cell.switchControl.setOn(false, animated: true)
                        }
                    }
                }
            })
            
            <<< ButtonRow("change_pin_code", { row in
                row.title = "Change PIN code"
            }).cellUpdate({ cell, row in
                cell.textLabel?.textAlignment = .left
                cell.imageView?.image = UIImage(named: "form-pincode")
            }).onCellSelection({ cell, row in
                controller.performSegue(withIdentifier: "ChangePincodeSegue", sender: nil)
            })
            
    }
    
    private func buildAboutSection(_ controller: UIViewController) {
        form +++ Section("About Raivo", { section in
            section.tag = "about"
        })
    
            <<< LabelRow("version", { row in
                row.title = "Version"
                row.value = AppHelper.version + " (build-" + String(AppHelper.build) + ")"
            }).cellUpdate({ cell, row in
                cell.imageView?.image = UIImage(named: "form-version")
            })
            
            <<< LabelRow("compilation", { row in
                row.title = "Compilation"
                row.value = AppHelper.compilation
            }).cellUpdate({ cell, row in
                cell.imageView?.image = UIImage(named: "form-compilation")
            })
            
            <<< LabelRow("author", { row in
                row.title = "Author"
                row.value = "@finnwea"
            }).cellUpdate({ cell, row in
                cell.imageView?.image = UIImage(named: "form-author")
            })
            
            <<< ButtonRow("report_a_bug", { row in
                row.title = "Report a bug"
            }).cellUpdate({ cell, row in
                cell.textLabel?.textAlignment = .left
                cell.imageView?.image = UIImage(named: "form-bug")
            }).onCellSelection({ cell, row in
                UIApplication.shared.open(URL(string: "https://github.com/tijme/raivo/issues")!, options: [:])
            })
    }
    
    private func buildLegalSection(_ controller: UIViewController) {
        form +++ Section("Legal", { section in
            section.tag = "legal"
        })
    
            <<< ButtonRow("privacy_policy", { row in
                row.title = "Privacy policy"
            }).cellUpdate({ cell, row in
                cell.textLabel?.textAlignment = .left
                cell.imageView?.image = UIImage(named: "form-privacy")
            }).onCellSelection({ cell, row in
                UIApplication.shared.open(URL(string: "https://github.com/tijme/raivo/blob/master/PRIVACY.md")!, options: [:])
            })
            
            <<< ButtonRow("security_policy", { row in
                row.title = "Security policy"
            }).cellUpdate({ cell, row in
                cell.textLabel?.textAlignment = .left
                cell.imageView?.image = UIImage(named: "form-security")
            }).onCellSelection({ cell, row in
                UIApplication.shared.open(URL(string: "https://github.com/tijme/raivo/blob/master/SECURITY.md")!, options: [:])
            })
            
            <<< ButtonRow("license", { row in
                row.title = "Raivo license"
            }).cellUpdate({ cell, row in
                cell.textLabel?.textAlignment = .left
                cell.imageView?.image = UIImage(named: "form-license")
            }).onCellSelection({ cell, row in
                UIApplication.shared.open(URL(string: "https://github.com/tijme/raivo/blob/master/LICENSE.md")!, options: [:])
            })
    }
    
    private func buildAdvancedSection(_ controller: UIViewController) {
        form +++ Section("Advanced", { section in
            section.tag = "advanced"
            
            let footerTitle = "Signing out will remove all data from your device."
            if [MockSyncer.UNIQUE_ID, OfflineSyncer.UNIQUE_ID].contains(SyncerHelper.getSyncer().UNIQUE_ID) {
                section.footer = HeaderFooterView(title: footerTitle)
            } else {
                section.footer = HeaderFooterView(title: footerTitle + " Data that has already been synced will remain at your synchronization provider.")
            }
        })
            
            <<< ButtonRow("sign_out", { row in
                row.title = "Sign out of Raivo"
            }).cellUpdate({ cell, row in
                cell.textLabel?.textAlignment = .left
                cell.imageView?.image = UIImage(named: "form-logout")
            }).onCellSelection({ cell, row in
                let refreshAlert = UIAlertController(
                    title: "Are you sure?",
                    message: "Your local Raivo data will be deleted.",
                    preferredStyle: UIAlertController.Style.alert
                )
                
                refreshAlert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action: UIAlertAction!) in
                    StateHelper.reset()
                    (MyApplication.shared.delegate as! AppDelegate).updateStoryboard()
                }))
                
                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                    
                }))
                
                controller.present(refreshAlert, animated: true, completion: nil)
            })
    }
    
}
