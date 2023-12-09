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
