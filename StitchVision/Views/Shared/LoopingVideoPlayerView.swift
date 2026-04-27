import SwiftUI
import AVFoundation

struct LoopingVideoPlayerView: UIViewRepresentable {
    let videoName: String
    var extensionName: String = "mp4"

    func makeUIView(context: Context) -> LoopingVideoPlayerUIView {
        let view = LoopingVideoPlayerUIView()
        view.loadVideo(name: videoName, ext: extensionName)
        return view
    }

    func updateUIView(_ uiView: LoopingVideoPlayerUIView, context: Context) {}
}

class LoopingVideoPlayerUIView: UIView {
    private var player: AVQueuePlayer?
    private var playerLooper: AVPlayerLooper?
    private var playerLayer: AVPlayerLayer?

    func loadVideo(name: String, ext: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            print("Video not found: \(name).\(ext)")
            return
        }

        let playerItem = AVPlayerItem(url: url)
        let queuePlayer = AVQueuePlayer(playerItem: playerItem)
        queuePlayer.isMuted = true

        let looper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)

        let layer = AVPlayerLayer(player: queuePlayer)
        layer.videoGravity = .resizeAspect
        layer.frame = bounds

        self.layer.addSublayer(layer)
        self.playerLayer = layer
        self.player = queuePlayer
        self.playerLooper = looper

        queuePlayer.play()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
}
