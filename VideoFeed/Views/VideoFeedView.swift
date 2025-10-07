//
//  ContentView.swift
//  VideoFeed
//
//  Created by Rola Kitaphanich on 2025-10-03.
//

import SwiftUI
import CoreData
import AVKit

struct VideoFeedView: View {
    @StateObject var viewModel: VideoFeedViewModel
    @StateObject var videoLoader: VideoLoader
    @State var currentIndex: Int = 500
    @State private var isResetting = false
    var bufferCount = 3
    
     var body: some View {
         GeometryReader { proxy in
             if !viewModel.errorMessage.isEmpty {
                 VStack {
                     Spacer()
                     Text(viewModel.errorMessage).foregroundColor(.red)
                     .frame(maxWidth: .infinity)
                     .multilineTextAlignment(.center)
                     Spacer()
                 }
             }
             else {
                 ScrollViewReader { scrollProxy in
                     ScrollView(.vertical, showsIndicators: false) {
                         LazyVStack(spacing: 0) {
                             //add the first few videos to the end and to the beginning so that when it reaches the end of the scroll there is no flickering
                             let loopedVideos = viewModel.videos.suffix(bufferCount) + viewModel.videos + viewModel.videos.prefix(bufferCount)
                             ForEach(loopedVideos.enumerated(), id: \.offset) { index, video in
                                 VideoPlayerView(player: videoLoader.players[index] ?? AVPlayer()).containerRelativeFrame([.horizontal, .vertical])
                                     .id(index)
                                     .frame(height: proxy.size.height)
                                     .onAppear {
                                         guard !isResetting else { return }
                                         // Preload current + next 2 videos
                                         for i in index..<(index + 2) {
                                             let url = URL(string: viewModel.videos[i % viewModel.videos.count].urlString)!
                                             videoLoader.preloadVideo(at: i, url: url)
                                         }
                                         // Clean up old video players
                                         videoLoader.cleanupUnusedPlayers(keeping: Array((index-1)...(index+3)))
                                         currentIndex = index
                                         // Handle looping
                                         if index == loopedVideos.count - 1 {
                                             resetScroll(to: 0, scrollProxy: scrollProxy)
                                         }
                                     }
                             }
                         }
                     }
                     //If the next video is not ready, dont allow the user to scroll
                     .scrollDisabled(
                        !videoLoader.isReady(index: currentIndex + 1)
                     )
                 }
             }
         }.onAppear {
             viewModel.getVideos()
             
         }
        .scrollTargetBehavior(.paging)
        .ignoresSafeArea()
     }
    
    private func resetScroll(to index: Int, scrollProxy: ScrollViewProxy) {
          isResetting = true
          DispatchQueue.main.async {
              withTransaction(Transaction(animation: nil)) {
                  scrollProxy.scrollTo(index, anchor: .top)
              }
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                  isResetting = false
              }
          }
      }
}
#Preview {
    VideoFeedView(viewModel: VideoFeedViewModel(apiService: ApiService()), videoLoader: VideoLoader())
}
