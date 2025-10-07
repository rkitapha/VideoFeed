//
//  VideoFeedApp.swift
//  VideoFeed
//
//  Created by Rola Kitaphanich on 2025-10-03.
//

import SwiftUI
import CoreData

@main
struct VideoFeedApp: App {
    var body: some Scene {
        WindowGroup {
            VideoFeedView(viewModel: VideoFeedViewModel(apiService: ApiService()), videoLoader: VideoLoader())
        }
    }
}
