//
//  App+WebSockets.swift
//  Internat
//
//  Created by Вадим on 15.04.17.
//
//

import Vapor

extension WebSocket {
    func send(_ json: JSON) throws {
        let js = try json.makeBytes()
        try send(js.string)
    }
}
