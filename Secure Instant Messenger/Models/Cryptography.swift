//
//  EncAndDec.swift
//  Secure Instant Messenger
//
//  Created by Mohammad Najafzadeh on 30/12/2021.
//

import Foundation

class Cryptography {
    
    // MARK: Encrypting the message
    func encryption(message: String) -> (String, String) {
        
        let messageInUInt8 = [UInt8](message.utf8)
        var ciphertext = [UInt8]()
        
        // Generating a Random String based on the input length
        func randomString(length: Int) -> String {
            let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            return String((0..<length).map{ _ in letters.randomElement()! })
        }
        
        let key = randomString(length: message.count)
        let keyInUInt8 = [UInt8](key.utf8)
        
        // XORing key and ciphertext
        for i in messageInUInt8.enumerated() {
            ciphertext.append(i.element ^ keyInUInt8[i.offset])
        }
        
        let encodedCiphertext = Data(ciphertext).base64EncodedString()
        
        return (encodedCiphertext, key)
    }
    
    // Mark: Decryption the message
    func decryption(ciphertext: String, key: String) -> String {
        
        // Initializing two arrays
        var decrypted = [UInt8]()
        let key = [UInt8](key.utf8)
        
        // Decoding from base64
        let decodedCiphertext = Data(base64Encoded: ciphertext, options: [])!
        
        // Decryption by running XOR operation
        for i in decodedCiphertext.enumerated() {
            decrypted.append(i.element ^ key[i.offset])
        }
        
        // Encoding to utf8 to see the message
        let message = String(bytes: decrypted, encoding: String.Encoding.utf8)
        
        return message!
    }
    
}
