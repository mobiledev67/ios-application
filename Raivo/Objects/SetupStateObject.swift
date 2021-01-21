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
import RealmSwift

/// An object used during the app setup. It remembers all options that the user chose.
///
/// - Note This object is deleted (from memory) when the user finishes the setup.
class SetupStateObject {
    
    /// The ID of the selected synchronization provider
    var syncerID: String? = nil
    
    /// The user account belonging to the synchronization provider
    var account: SyncerAccount? = nil
    
    /// The challenge belonging to the synchronization provider
    var challenge: SyncerChallenge? = nil
    
    /// The encryption password
    var password: String? = nil
    
    /// The encryption key derived from the password and passcode
    var encryptionKey: Data? = nil
    
    /// Should enable biometric unlock
    var biometric: Bool = false
    
    /// Check if a challenge is available.
    ///
    /// - Returns: Positive if user is recovering data.
    public func recoveryMode() -> Bool {
        return challenge?.challenge != nil
    }
    
    /// Persist the current storage into storage
    public func persist() throws {
        // Set the current storage provider (e.g. iCloud/CloudKit)
        StorageHelper.shared.setSynchronizationProvider(syncerID!)
        
        // Set the current account identifier in both the keychain and the current app state
        StorageHelper.shared.setSynchronizationAccountIdentifier(account!.identifier)
        getAppDelegate().syncerAccountIdentifier = account!.identifier
        
        // Store the password in the keychain
        StorageHelper.shared.setEncryptionPassword(password!)
        
        // Create a Realm database
        getAppDelegate().updateEncryptionKey(encryptionKey!)
        
        // Create an empty database using the default realm configuration
        let _ = try! Realm(configuration: Realm.Configuration.defaultConfiguration)
        
        // Enable biometric unlock if needed
        if biometric {
            StorageHelper.shared.setEncryptionKey(encryptionKey!.base64EncodedString())
            StorageHelper.shared.setBiometricUnlockEnabled(true)
        }
    }
    
}
