//
//  ApiService.swift
//  VideoFeed
//
//  Created by Rola Kitaphanich on 2025-10-03.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case serverError(statusCode: Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "The URL provided was invalid."
        case .networkError(let error): return "A network error occurred: \(error.localizedDescription)"
        case .invalidResponse: return "The server returned an invalid response."
        case .decodingError(let error): return "Failed to decode data: \(error.localizedDescription)"
        case .serverError(let statusCode): return "Server error with status code: \(statusCode)"
        }
    }
}

protocol ApiServiceProtocol {
    func getVideos() async throws -> [String]?
}

struct ApiService: ApiServiceProtocol {
    
    let urlString = "https://cdn.dev.airxp.app/AgentVideos-HLS-Progressive/manifest.json"
    
    ///Get the video urls from the api
    func getVideos() async throws -> [String]? {
        guard let url = URL(string:urlString) else { return nil }
        do {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let videoResponse = try JSONDecoder().decode(VideoResponse.self, from: data)
                return videoResponse.videos
            }
            catch {
                throw APIError.decodingError(error)
            }
        } catch {
            throw APIError.invalidURL
        }
    }
}
