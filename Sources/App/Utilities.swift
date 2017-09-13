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

        let letters : [Character] = Array(
          "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".characters
        )

        let len = letters.count
        var randomString = ""

        #if os(Linux)
            srand(UInt32(time(nil)))
            for _ in 0..<length
            {
                let randomValue = Int(rand()) % len
                randomString.append(letters[randomValue])
            }
        #else
            for _ in 0 ..< length
            {
                let rand = Int(arc4random_uniform(UInt32(len)))
                randomString.append(letters[rand])
            }
        #endif
        return randomString
    }
}
