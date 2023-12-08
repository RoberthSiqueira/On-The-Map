import Foundation

struct UdacityRequest: Codable {
    let udacity: SessionRequest
}

struct SessionRequest: Codable {
    let username: String
    let password: String
}
