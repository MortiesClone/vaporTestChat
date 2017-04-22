import HTTP
import Vapor

class Translate {
    private var key: String
    private var drop: Droplet

    private var lastResponsedCode: String = ""

    init(key: String, drop: Droplet) {
        self.key = key
        self.drop = drop
    }

    private func getLastCode() -> String {
        return lastResponsedCode
    }

    public func getLangs() throws -> Node? {

        let response = try drop.client.post("https://translate.yandex.net/api/v1.5/tr.json/getLangs",
          query: [
            "key" : key,
            "ui" : "en"
          ]
        )

        guard let langs = response.data["langs"]?.object else {
            fatalError("Translate: error unwrapping \(#function)");
        }

        var node: [Node] = []

        for lang in langs {
            node.append(try [
              "k" : lang.key.string!,
              "v" : lang.value.string!
            ].makeNode())
        }

        let n = try node.makeNode()

        return n
    }

    public func translate(_ msg: String, toLang: String) throws -> String {
        var message = "Error"

        let response = try drop.client.post("https://translate.yandex.net/api/v1.5/tr.json/translate",
          query: [
            "key" : key,
            "text" : msg,
            "lang" : toLang
          ]
        )

        guard let code = response.data["code"]?.string else {
            fatalError("Translate: Error unwrapping code")
        }

        lastResponsedCode = code

        guard let text = response.data["text"]?.array else {
            fatalError("Translate: Error unwrapping text")
        }

        if let m = text.first?.string {
            message = m
        }

        return message
    }
}
