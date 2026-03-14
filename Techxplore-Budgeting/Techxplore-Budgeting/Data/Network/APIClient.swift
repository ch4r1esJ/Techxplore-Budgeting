//
//  APIClient.swift
//  Techxplore-Budgeting
//
//  Created by Charles Janjgava on 3/13/26.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(Int)
    case unknown(Error)
}

final class APIClient {
    static let baseURL = "http://bankingapp-alb-482506232.eu-central-1.elb.amazonaws.com"
    static let userId = "11111111-1111-1111-1111-111111111111"

    func get<T: Decodable>(_ path: String) async throws -> T {
        try await request(path: path, method: "GET", body: Optional<String>.none)
    }

    func post<T: Decodable, B: Encodable>(_ path: String, body: B) async throws -> T {
        try await request(path: path, method: "POST", body: body)
    }

    func put<B: Encodable>(_ path: String, body: B) async throws {
        let _: EmptyResponse = try await request(path: path, method: "PUT", body: body)
    }
    
    func delete<T: Decodable>(_ path: String) async throws -> T {
        try await request(path: path, method: "DELETE", body: Optional<String>.none)
    }

    private func request<T: Decodable, B: Encodable>(path: String, method: String, body: B?) async throws -> T {
        guard let url = URL(string: APIClient.baseURL + path) else { throw APIError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(APIClient.userId, forHTTPHeaderField: "X-User-Id")
        if let body { request.httpBody = try JSONEncoder().encode(body) }

        let (data, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            let body = String(data: data, encoding: .utf8) ?? "no body"
            print("HTTP \(http.statusCode): \(body)")
            throw APIError.serverError(http.statusCode)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Decoding error. Raw response: \(String(data: data, encoding: .utf8) ?? "nil")")
            throw APIError.decodingError
        }
    }
}

struct EmptyResponse: Decodable {}
