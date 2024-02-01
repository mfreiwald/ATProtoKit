//
//  APIClientService.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-28.
//

import Foundation

class APIClientService {

    private init() {}

    static func createRequest(forRequest requestURL: URL, andMethod httpMethod: HTTPMethod, contentTypeValue: String = "application/json", authorizationValue: String? = nil) -> URLRequest {
        var request = URLRequest(url: requestURL)
        request.httpMethod = httpMethod.rawValue

        if let authorizationValue {
            request.addValue(authorizationValue, forHTTPHeaderField: "Authorization")
        }
        request.addValue(contentTypeValue, forHTTPHeaderField: "Content-Type")
        return request
    }

    static func encode<T: Encodable>(_ jsonData: T) async throws -> Data {
        guard let httpBody = try? JSONSerialization.data(withJSONObject: jsonData) else { throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Error encoding request body"]) }
        return httpBody
    }

    static func sendRequest<T: Decodable>(_ request: URLRequest, jsonData: [String: Any] = [:], decodeTo: T.Type) async throws -> T {
        var urlRequest = request

        if !jsonData.isEmpty {
            guard let httpBody = try? JSONSerialization.data(withJSONObject: jsonData) else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Error encoding request body"])
            }

            urlRequest.httpBody = httpBody
        }

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error getting response"])
        }

//        print("Status Code: \(httpResponse.statusCode)")  // Debugging line
//        print("Response Headers: \(httpResponse.allHeaderFields)")  // Debugging line

        guard httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }

    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
}
