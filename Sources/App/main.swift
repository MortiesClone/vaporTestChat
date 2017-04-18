import Vapor
import Foundation

let drop = Droplet()

var lastClient: Client? = nil

var rooms: [String: Room] = [:]
var users = 0

drop.get { request in
    return try drop.view.make("main.leaf")
}

drop.socket("ws") { (request, ws) in
    print("New WebSocket")
    
    users += 1
    
    let client = Client(ws: ws)
    /*try ws.send(try JSON(node: [
        "clientId":client.getId()
        ]))*/
    
    if let last = lastClient {
        let room = Room(clients: [last, client])
        rooms[room.getId()] = room
        client.setRoomId(room.getId())
        last.setRoomId(room.getId())
        
        try ws.send(try JSON(node: [
            "roomId":room.getId()
            ]))
        try last.sendMessage(try JSON(node: [
            "roomId":room.getId()
            ]))
        
        lastClient = nil
    } else {
        lastClient = client
    }
    
    ws.onText = { ws,text  in
        let json = try JSON(bytes: Array(text.utf8))
        if let roomId = json.object?["roomId"]?.string,
            let msg = json.object?["msg"]?.string {
            
            if let room = rooms[roomId] {
                try room.send(text: msg, sender: client)
            }
        }
    }

    ws.onClose = { ws, code, reason, clean in
        print("WebSocket closed")
        
        if let roomId = client.getRoomId() {
            if let room = rooms[roomId] {
                try room.sendClientLeaves(client)
                rooms.removeValue(forKey: roomId)
            }
        }
        if (lastClient == client) {
            lastClient = nil
        }
        users -= 1
    }
}

drop.get("/online") { req in
    return "online: \(users)"
}

/*drop.get { req in
    return try drop.view.make("welcome", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}*/

//drop.resource("posts", PostController())

drop.run()
