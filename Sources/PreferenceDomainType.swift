//
//  PreferenceDomainType.swift
//  SecureDefaults
//
//  Created by Benedetto on 8/1/18.
//

import Foundation

public protocol PreferenceDomainType : Codable {
    /// The name of your PreferenceDomainType
    /// - Note: Generally you will want to use a
    /// a reverse domain style string.  This value
    /// will be used to register with the UserDefaults.
    static var name : String { get }
    /// The key to use for the defaults dictionary
    static var key : String { get }
    /// Tag for Keychain Storage & Retrieval
    static var tag : String { get }
    /// Registers your PreferenceDomain with the User Defaults
    /// - Note: Uses the 'key' var as your key, with a String value
    /// ie: ["myPreferenceKey" : "some hashed value"]
    /// - Returns: Void
    func register() -> Void
    /// Saving the preference domain type to the suite
    ///
    /// - Parameter input: an encrypted string of the PreferenceDomainType
    /// - Returns: Void
    func save(encryptedPayload : String) -> Void
    /// Retrieving the encrypted Payload
    /// - Note: The default implementation retrieves the payload from the suite
    /// using the key.
    /// - Returns: A String value representing the encrypted payload.
    static func encryptedPayload() throws -> String
}

public extension PreferenceDomainType {
    
    func register() -> Void {
        UserDefaults.standard.addSuite(named: Self.name)
        let suite = UserDefaults(suiteName: Self.name)
        suite?.register(defaults: [Self.key : ""])
    }
    
    func save(encryptedPayload: String) -> Void {
        let suite = UserDefaults(suiteName: Self.name)
        suite?.set(encryptedPayload, forKey: Self.key)
        suite?.synchronize()
        UserDefaults.standard.synchronize()
    }
    
    static func encryptedPayload() throws -> String {
        let suite = UserDefaults(suiteName: Self.name)
        guard let result = suite?.string(forKey: Self.key) else {
            throw PreferenceDomainError.couldNotRetrieveEncryptionPayload
        }

        return result
    }
}

enum PreferenceDomainError : Error {
    case couldNotRetrieveEncryptionPayload
}
