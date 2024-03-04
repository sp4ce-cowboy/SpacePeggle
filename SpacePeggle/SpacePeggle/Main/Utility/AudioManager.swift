import SwiftUI
import AVFoundation

class AudioManager: NSObject, AVAudioPlayerDelegate {
    static let shared = AudioManager() // Singleton instance
    private var audioPlayer: AVAudioPlayer?
    private var isPlaying = false

    override init() {
        super.init()
        setupAudioPlayer()
        audioPlayer?.prepareToPlay()
        Logger.log("AudioManager is initialized", self)
    }

    func setupAudioPlayer() {

        guard let audioData = NSDataAsset(name: "field-of-memories-soundtrack")?.data else {
            Logger.log("Background audio asset not found", self)
            return
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(data: audioData)
            audioPlayer?.delegate = self
            audioPlayer?.numberOfLoops = -1 // Loop indefinitely
            audioPlayer?.volume = 1
        } catch {
            Logger.log("Failed to initialize audio player: \(error)", self)
        }
    }

    func play() {
        audioPlayer?.play()
        isPlaying = true
    }

    func pause() {
        audioPlayer?.pause()
        isPlaying = false
    }

    func stop() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        isPlaying = false
    }

    func mute() {
        audioPlayer?.volume = 0
    }

    func unmute() {
        audioPlayer?.volume = 1.0
    }

    func toggle() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
}
