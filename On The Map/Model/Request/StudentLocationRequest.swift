import Foundation

struct StudentLocationRequest: Codable {
    let userId: String
    let firstName: String
    let lastName: String
    let locality: String
    let mediaURL: String
    let latitude: String
    let longitude: String

    enum CodingKeys: String, CodingKey {
        case userId = "uniqueKey"
        case firstName
        case lastName
        case locality = "mapString"
        case mediaURL
        case latitude
        case longitude
    }
}
