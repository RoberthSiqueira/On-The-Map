import Foundation

struct ErrorResponse: Codable {
    let error: String
    let status: Int
}

extension ErrorResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
