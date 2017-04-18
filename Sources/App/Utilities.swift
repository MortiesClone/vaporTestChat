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
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            #if os(Linux)
                srandom(UInt32(time(nil)))
                let rand = UInt32(random())%len
            #else
                let rand = arc4random_uniform(len)
            #endif
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}
