import SwiftUI
import AVFoundation

/// Explicit Internal class to ensure that external clients cannot
/// interfere with singleton instance.
internal class AudioManager: NSObject, AVAudioPlayerDelegate {
    internal static let shared = AudioManager() // Singleton instance
    private var backgroundAudioPlayer: AVAudioPlayer?
    private var soundEffectPlayer: AVAudioPlayer?
    private var isPlaying = false

    override init() {
        super.init()
        setupAudioPlayer()
        backgroundAudioPlayer?.prepareToPlay()
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
            backgroundAudioPlayer = try AVAudioPlayer(data: audioData)
            backgroundAudioPlayer?.delegate = self
            backgroundAudioPlayer?.numberOfLoops = -1 // Loop indefinitely
            backgroundAudioPlayer?.volume = 1
        } catch {
            Logger.log("Failed to initialize audio player: \(error)", self)
        }
    }

    func play() {
        backgroundAudioPlayer?.play()
        isPlaying = true
    }

    func pause() {
        backgroundAudioPlayer?.pause()
        isPlaying = false
    }

    func stop() {
        backgroundAudioPlayer?.stop()
        backgroundAudioPlayer?.currentTime = 0
        isPlaying = false
    }

    func mute() {
        backgroundAudioPlayer?.volume = 0
    }

    func unmute() {
        backgroundAudioPlayer?.volume = 1.0
    }

    func toggle() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
}
