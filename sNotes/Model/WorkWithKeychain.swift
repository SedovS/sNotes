//
//  WorkWithKeychain.swift
//  sNotes
//
//  Created by Sergey Sedov on 25.05.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}

class WorkWithKeychain {
        
    enum keyKeychain: String {
        case account = "sNotes"
        case passcode = "passCode"
    }
    
    
    //MARK: - Passcode
    //Return true if the code is in the keychain
    static public func isPasscode() -> Bool {
        return keychainCheck(service: .passcode)
    }
    
    static public func checkPassCode(passCode: String) -> Bool {
        passCode.caseInsensitiveCompare(getPassCode()) == .orderedSame
    }
    
    //return personal code
    static private func getPassCode() -> String {
        let data = read(service: .passcode)
        let pc = String(data: data!, encoding: .utf8)
        return pc!
    }
    
    //save personal code
    static public func setPassCode(passCode: String) {
        let data = passCode.data(using: .utf8)!
        write(service: .passcode, data: data)
    }
        
    
    // MARK: - Work with Keychein
    // MARK: - check
    //checks for data in the keychain
    //returns true - if there is data
    static private func keychainCheck(service: keyKeychain) -> Bool {
        if read(service: service) == nil {
            return false
        } else {
            return true
        }
    }
    // MARK: - reed
    static private func read(service: keyKeychain) -> Data? {
        do {
            let t = try readKeychain(service: service)
            return (t as! Data)
        } catch  {
            print("Error read, service=",service)
            return nil
        }
    }
    
    static private func readKeychain(service: keyKeychain) throws -> Any? {
        
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: keyKeychain.account.rawValue,
                                    kSecAttrService as String: service.rawValue,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnData as String: true,
                                    kSecReturnAttributes as String: true]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        
        guard let existingItem = item as? [String : Any],
            let data = existingItem[kSecValueData as String] as? Data
            else {
                throw KeychainError.unexpectedPasswordData
        }
        print("readKeychain ok, service=",service)
        return data
    }
    
    // MARK: - write
    static private func write(service: keyKeychain, data: Data) {
        do {
            let _ = try setKeychain(service: service, data: data)
        } catch  {
            print("Error write, service=",service)
        }
    }
    
    static private func setKeychain(service: keyKeychain, data: Data) throws -> Any? {
        
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: keyKeychain.account.rawValue,
                                    kSecAttrService as String: service.rawValue,
                                    kSecValueData as String: data]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw
                KeychainError.unhandledError(status: status)
        }
        print("Set Keyshein OK, service=",service)
        return status
    }
    
    // MARK: - update
    static private func updateKeychain(service: keyKeychain, data: Data) {
        
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: keyKeychain.account.rawValue,
                                    kSecAttrService as String: service.rawValue,
                                    kSecValueData as String: data]
        
        let attributesToUpdate: [String: Any] = [kSecAttrAccount as String: keyKeychain.account.rawValue,
                                                 kSecAttrService as String: service.rawValue,
                                                 kSecValueData as String: data]
        
        let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        if status != errSecSuccess {
            print("updateKeychain error, service=",service)
        } else {
            print("updateKeychain OK, service=",service)
        }
    }
    
    // MARK: - clear
    static public func clearKeychain() {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: keyKeychain.account.rawValue]
        let status = SecItemDelete(query as CFDictionary)
        
        if status != errSecSuccess {
            print("clearKeychain ERRROR")
        } else {
            print("clearKeychain OK")
        }
    }
}
