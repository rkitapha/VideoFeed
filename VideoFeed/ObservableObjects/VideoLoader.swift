//
//  VideoLoader.swift
//  VideoFeed
//
//  Created by Rola Kitaphanich on 2025-10-06.
//

import AVKit
import Combine

class VideoLoader: ObservableObject {
    @Published var players: [Int: AVPlayer] = [:]
    @Published var isLoading: [Int: Bool] = [:]

    private var cancellables = Set<AnyCancellable>()

      /// Preload a video at a specific index
      func preloadVideo(at index: Int, url: URL) {
          guard players[index] == nil else { return }
          
          let asset = AVURLAsset(url: url)
          let keys = ["playable", "duration", "tracks"]

          asset.loadValuesAsynchronously(forKeys: keys) { [self] in
              var error: NSError? = nil
              let status = asset.statusOfValue(forKey: "playable", error: &error)
              
              if status == .loaded {
                  let playerItem = AVPlayerItem(asset: asset)
                  let player = AVPlayer(playerItem: playerItem)
                  
                  // Observe buffering status
                  playerItem.publisher(for: \.isPlaybackLikelyToKeepUp)
                      .receive(on: DispatchQueue.main)
                      .sink { [weak self] ready in
                          self?.isLoading[index] = !ready
                      }
                      .store(in: &self.cancellables)
                  
                  DispatchQueue.main.async {
                      self.players[index] = player
                      player.play()
                  }
              }
          }
      }

      ///Check if a video is ready
      func isReady(index: Int) -> Bool {
          return players[index] != nil && isLoading[index] == false
      }

      ///Cleanup old players to save memory
      func cleanupUnusedPlayers(keeping indices: [Int]) {
          for (key, player) in players {
              if !indices.contains(key) {
                  player.pause()
                  players.removeValue(forKey: key)
                  isLoading.removeValue(forKey: key)
              }
          }
      }
}
