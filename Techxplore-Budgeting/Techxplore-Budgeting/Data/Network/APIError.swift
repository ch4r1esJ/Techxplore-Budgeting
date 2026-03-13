//
//  APIError.swift
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
    static let baseURL = "https://your-api-base-url.com/api"
    static let userId = "3fa85f64-5717-4562-b3fc-2c963f66afa6"

    func get<T: Decodable>(_ path: String) async throws -> T {
        try await request(path: path, method: "GET", body: Optional<String>.none)
    }

    func post<T: Decodable, B: Encodable>(_ path: String, body: B) async throws -> T {
        try await request(path: path, method: "POST", body: body)
    }

    func put<B: Encodable>(_ path: String, body: B) async throws {
        let _: EmptyResponse = try await request(path: path, method: "PUT", body: body)
    }

    private func request<T: Decodable, B: Encodable>(path: String, method: String, body: B?) async throws -> T {
        guard let url = URL(string: APIClient.baseURL + path) else { throw APIError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let body { request.httpBody = try JSONEncoder().encode(body) }

        let (data, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw APIError.serverError(http.statusCode)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingError
        }
    }
}

private struct EmptyResponse: Decodable {}
