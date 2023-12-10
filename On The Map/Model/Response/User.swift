import Foundation

struct User: Codable {
    let firstName: String
    let lastName: String
    let location: StudentLocation?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case location
    }
}
