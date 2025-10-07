//
//  VideoPlayerView.swift
//  VideoFeed
//
//  Created by Rola Kitaphanich on 2025-10-03.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    var player = AVPlayer()
     
    init(player: AVPlayer) {
        self.player = player
     }
    
    var body: some View {
        ZStack {
            VideoPlayer(player: player)
                .onAppear {
                    player.seek(to: .zero)
                    player.play()
                }
                .onDisappear {
                    player.pause()
                    player.seek(to: .zero)
                }
                .ignoresSafeArea()
        }
        .safeAreaInset(edge: .bottom) {
            VStack {
                VideoTextField(player: player)
            }
            .padding()
            .background(Color.black)
        }
    }
}

#Preview {
    VideoPlayerView(player: AVPlayer(url: URL(string: "https://cdn.dev.airxp.app/AgentVideos-HLS-Progressive/000298e8-08bc-4d79-adfc-459d7b18edad/master.m3u8")!))
}
