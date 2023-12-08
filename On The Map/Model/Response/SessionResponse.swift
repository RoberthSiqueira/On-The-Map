import Foundation

struct SessionResponse: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let registered: Bool
    let userId: String

    enum CodingKeys: String, CodingKey {
        case registered
        case userId = "key"
    }
}

struct Session: Codable {
    let id: String
    let expiration: String
}

//{
//    "account":{
//        "registered":true,
//        "key":"3903878747"
//    },
//    "session":{
//        "id":"1457628510Sc18f2ad4cd3fb317fb8e028488694088",
//        "expiration":"2015-05-10T16:48:30.760460Z"
//    }
//}
