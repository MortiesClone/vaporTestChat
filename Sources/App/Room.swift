//
//  Room.swift
//  Internat
//
//  Created by Вадим on 14.04.17.
//
//

import Vapor

class Room {
    private var id = ""

    private var clients: [Client]

    init(clients: [Client]) {
        id = Utilities.randomString(length: 200)
        self.clients = clients
    }

    public func getId() -> String {
        return id
    }

    public func send(text: String, sender: Client, translate: Bool) throws {
        for client in clients {
            try client.sendMessage(try JSON(node: [
                "text" : text,
                "isSender" : client == sender,
                "translate" : translate,
                "isLeave" : false
                ]))
        }
    }

    public func sendClientLeaves(_ leaves: Client) throws {
        for client in clients {
            if client != leaves {
                try client.sendMessage(try JSON(node: [
                    "text": "anonim leave from chat",
                    "isLeave" : true
                    ]))
            }
        }
    }
}
