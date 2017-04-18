import Vapor

class Client: Equatable {
    private var id = ""
    
    private var ws: WebSocket
    
    private var roomId: String?
    
    init(ws: WebSocket) {
        self.ws = ws
        id = Utilities.randomString(length: 128)
    }
    
    public func getId() -> String {
        return id
    }
    
    public func getRoomId () -> String? {
        return roomId
    }
    
    public func setRoomId(_ roomId: String) {
        self.roomId = roomId
    }
    
    public func sendMessage(_ json: JSON) throws {
        try ws.send(json)
    }
    
    public func sendMessage(_ text: String) throws {
        try ws.send(text)
    }
    
    public static func ==(lhs: Client, rhs: Client) -> Bool {
        return lhs.getId() == rhs.getId()
    }
}
