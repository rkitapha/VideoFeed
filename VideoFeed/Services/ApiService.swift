//
//  ApiService.swift
//  VideoFeed
//
//  Created by Rola Kitaphanich on 2025-10-03.
//

import Foundation

protocol ApiServiceProtocol {
    func getVideos() async throws -> [String]?
}

struct ApiService: ApiServiceProtocol {
    
    let urlString = "https://cdn.dev.airxp.app/AgentVideos-HLS-Progressive/manifest.json"
    
    ///Get the video urls from the api
    func getVideos() async throws -> [String]? {
        guard let url = URL(string:urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let videoResponse = try JSONDecoder().decode(VideoResponse.self, from: data)
            return videoResponse.videos
        } catch {
            print("ERROR")
        }
        
        return nil
    }
}
