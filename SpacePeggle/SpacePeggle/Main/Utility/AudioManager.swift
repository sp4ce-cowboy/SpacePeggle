import SwiftUI
import AVFoundation

/// Explicit internal class to ensure that external clients cannot
/// interfere with singleton instance. Singleton anti-pattern used here
/// in line with Apple's AVAudioSession sharedInstance.
internal class AudioManager: NSObject, AVAudioPlayerDelegate {
    internal static let shared = AudioManager() // Singleton instance
    private var backgroundAudioPlayer: AVAudioPlayer?
    private var soundEffectPlayers: [String: AVAudioPlayer] = [:] // Cache sound effect players
    private var isPlaying = false

    private let SOUND_EFFECTS_ENABLED = Constants.SOUND_EFFECTS_ENABLED

    override init() {
        super.init()
        setupAudioPlayer()
        backgroundAudioPlayer?.prepareToPlay()
        Logger.log("AudioManager is initialized", self)
    }

    func setupAudioPlayer() {
        let soundName = Constants.BACKGROUND_AUDIO

        guard let soundURL = Bundle.main.url(forResource: soundName,
                                             withExtension: nil) else {
            Logger.log("Sound effect \(soundName) not found", self)
            return
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            backgroundAudioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            backgroundAudioPlayer?.delegate = self
            backgroundAudioPlayer?.numberOfLoops = -1 // Loop indefinitely
            backgroundAudioPlayer?.volume = 0.8
            backgroundAudioPlayer?.prepareToPlay()
        } catch {
            Logger.log("Failed to play sound effect \(soundName): \(error)", self)
        }
    }

    // Play background music
    func play() {
        if !isPlaying {
            backgroundAudioPlayer?.play()
            isPlaying = true
        }
    }

    // Pause background music
    func pause() {
        if isPlaying {
            backgroundAudioPlayer?.pause()
            isPlaying = false
        }
    }

    // Stop background music
    func stop() {
        backgroundAudioPlayer?.stop()
        backgroundAudioPlayer?.currentTime = 0
        isPlaying = false
    }

    // Mute background music
    func mute() {
        backgroundAudioPlayer?.volume = 0
    }

    // Unmute background music
    func unmute() {
        backgroundAudioPlayer?.volume = 1.0
    }

    // Toggle play/pause background music
    func toggle() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }

    // Play a sound effect
    func playSoundEffect(named soundName: String) {
        guard SOUND_EFFECTS_ENABLED else {
            return
        }
        // Attempt to use a cached player if available
        if let player = soundEffectPlayers[soundName] {
            player.play()
        } else {
            // Create a new player for the sound effect
            guard let soundURL = Bundle.main.url(forResource: soundName, withExtension: nil) else {
                Logger.log("Sound effect \(soundName) not found", self)
                return
            }
            do {
                let player = try AVAudioPlayer(contentsOf: soundURL)
                player.volume = 1.0
                player.prepareToPlay()
                player.play()
                soundEffectPlayers[soundName] = player
            } catch {
                Logger.log("Failed to play sound effect \(soundName): \(error)", self)
            }
        }
    }

    func playWinSoundEffect() {
        playSoundEffect(named: "success.mp3")
    }

    func playLoseSoundEffect() {
        playSoundEffect(named: "lose.mp3")
    }

    func playHitEffect() {
        playSoundEffect(named: "hit-sound.mp3")
    }

    func playSpecialEffect() {
        playSoundEffect(named: "jump.mp3")
    }

    func playBeepEffect() {
        playSoundEffect(named: "beep.mp3")
    }
}
