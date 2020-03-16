//
//  EncryptionProvider.swift
//  SecureDefaults
//
//  Created by Benedetto on 3/11/20.
//

import Foundation

/// A protocol describing how a provider should encrypt data
public protocol EncryptionProvider {
    
    associatedtype Domain
    associatedtype EncryptedType
    
    /// Encrypting data to a domain
    /// - Parameter data: the data to encrypt
    func encrypt(data: Domain) throws -> EncryptedType
    /// Decrypting data from a domain
    /// - Parameter data: the data to decrypt
    func decrypt(data: EncryptedType) throws -> Domain
    /// Removes Keychain data associated with the provider
    func nuke() throws -> Void

}