//
//  VideoFeedViewModel.swift
//  VideoFeed
//
//  Created by Rola Kitaphanich on 2025-10-03.
//

import Combine
import SwiftUI

@MainActor
class VideoFeedViewModel: ObservableObject {
    
    @Published var videos: [Video] = []
    
    private let apiService: ApiServiceProtocol
    
    private(set) var isLoading = false
    
    init(apiService: ApiServiceProtocol) {
        self.apiService = apiService
    }
    
    ///call get videos from api 
    func getVideos() {
        Task {
            if let videoURLS = try await apiService.getVideos() {
                for videoURL in videoURLS.prefix(5) {
                    videos.append(Video(urlString: videoURL))
                }
            }
        }
    }
}
