import Foundation

class Client {

    enum Endpoints {
        static let baseURL: String = "https://onthemap-api.udacity.com/v1"

        case login
        case logout

        var stringValue: String {
            switch self {
                case .login, .logout:
                    return Endpoints.baseURL + "/session"
            }
        }

        var url: URL {
            return URL(string: stringValue) ?? URL(string:"https://www.udacity.com")!
        }
    }

    class func postSession(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let sessionRequest = SessionRequest(username: username, password: password)
        let body = UdacityRequest(udacity: sessionRequest)
        taskPOSTRequest(url: Endpoints.login.url, body: body, response: SessionResponse.self) { result in
            switch result {
                case .success:
                    completion(true, nil)
                case .failure(let error):
                    completion(false, error)
            }
        }
    }

    class func deleteSession(completion: @escaping (Bool, Error?) -> Void) {
        taskDELETERequest(url: Endpoints.logout.url, response: SessionResponse.self) { result in
            switch result {
                case .success:
                    completion(true, nil)
                case .failure(let error):
                    completion(false, error)
            }
        }
    }

    private class func taskPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, body: RequestType, response: ResponseType.Type, completion: @escaping (Result<ResponseType, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()

        do {
            request.httpBody = try encoder.encode(body)
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }

        let urlSession = URLSession.shared

        urlSession.dataTask(with: request) { data, urlResponse, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.badURL))
                }
                return
            }

            let decoder = JSONDecoder()
            let newData = data.subdata(in: 5..<data.count)

            do {
                let object = try decoder.decode(response, from: newData)
                DispatchQueue.main.async {
                    completion(.success(object))
                }
            } catch {
                do {
                    let error = try decoder.decode(ErrorResponse.self, from: newData) as Error
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }.resume()
    }

    private class func taskDELETERequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping (Result<ResponseType, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }

        let encoder = JSONEncoder()

        let urlSession = URLSession.shared

        urlSession.dataTask(with: request) { data, urlResponse, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.badURL))
                }
                return
            }

            let decoder = JSONDecoder()
            let newData = data.subdata(in: 5..<data.count)

            do {
                let object = try decoder.decode(response, from: newData)
                DispatchQueue.main.async {
                    completion(.success(object))
                }
            } catch {
                do {
                    let error = try decoder.decode(ErrorResponse.self, from: newData) as Error
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }.resume()
    }

    private class func taskGETRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping (Result<ResponseType, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let urlSession = URLSession.shared

        urlSession.dataTask(with: request) { data, urlResponse, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.badURL))
                }
                return
            }

            let decoder = JSONDecoder()
            let newData = data.subdata(in: 5..<data.count)

            do {
                let object = try decoder.decode(response, from: newData)
                DispatchQueue.main.async {
                    completion(.success(object))
                }
            } catch {
                do {
                    let error = try decoder.decode(ErrorResponse.self, from: newData) as Error
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }.resume()
    }
}

enum NetworkError: Error {
    case badURL
}
