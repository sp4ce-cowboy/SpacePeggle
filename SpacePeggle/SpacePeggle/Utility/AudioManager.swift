import SwiftUI
import AVFoundation

class AudioManager: NSObject, AVAudioPlayerDelegate {
    static let shared = AudioManager() // Singleton instance
    var audioPlayer: AVAudioPlayer?

    override init() {
        super.init()
        setupAudioPlayer()
    }

    func setupAudioPlayer() {
        guard let audioData = NSDataAsset(name: "field-of-memories-soundtrack")?.data else {
            Logger.log("Background audio asset not found", self)
            return
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(data: audioData)
            audioPlayer?.delegate = self
            audioPlayer?.numberOfLoops = -1 // Loop indefinitely
            audioPlayer?.prepareToPlay()
            audioPlayer?.volume = 1
        } catch {
            Logger.log("Failed to initialize audio player: \(error)", self)
        }
    }

    func play() {
        audioPlayer?.currentTime = 0
        audioPlayer?.play()
    }

    func pause() {
        audioPlayer?.pause()
    }

    func stop() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
    }
}
