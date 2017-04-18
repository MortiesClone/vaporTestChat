//
//  Utilities.swift
//  Internat
//
//  Created by Вадим on 15.04.17.
//
//

import Foundation

class Utilities {
    public static func randomString(length: Int) -> String {
        
        let letters : String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = letters.characters.count
        
        var randomString = ""
        
        #if os(Linux)
            
            srand(UInt32(time(nil)))
            
            for _ in 0..<length
            {
                let randomValue = (random() % len) + 1
                
                randomString += String(letters[letters.index(letters.startIndex, offsetBy: Int(randomValue))])
            }
            
        #else
            for _ in 0 ..< length
            {
                let rand = arc4random_uniform(UInt32(len))
                
                randomString += "\(letters[letters.index(letters.startIndex, offsetBy: Int(rand))])"
            }
        #endif
        
        return randomString
    }
}
