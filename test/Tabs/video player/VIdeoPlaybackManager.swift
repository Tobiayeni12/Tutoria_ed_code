//
//  VIdeoPlaybackManager.swift
//  test
//
//  Created by Tobi Ayeni on 2025-06-20.
//
import AVKit

class VideoPlaybackManager {
    static let shared = VideoPlaybackManager()

    let player: AVQueuePlayer
    private var looper: AVPlayerLooper?

    private init() {
        let url = Bundle.main.url(forResource: "tutoria_vid", withExtension: "mp4")!
        let item = AVPlayerItem(url: url)
        self.player = AVQueuePlayer()
        self.looper = AVPlayerLooper(player: player, templateItem: item)
    }
}

