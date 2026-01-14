import SwiftUI
import AVFoundation
import AudioToolbox

// --- TECHSOUND CONTINUA IGUAL ---
@MainActor
class TechSound {
    enum SoundType { case click, move, success, error, glitch, typewriter, staticNoise }
    static func play(_ type: SoundType) {
        let soundID: SystemSoundID
        switch type {
            case .click: soundID = 1104
            case .move: soundID = 1103
            case .success: soundID = 1022
            case .error: soundID = 1053
            case .glitch: soundID = 1057
            case .staticNoise: soundID = 1057
            case .typewriter: return
        }
        AudioServicesPlaySystemSound(soundID)
    }
}

// --- AUDIOMANAGER ACTOR ---
final actor AudioManager {
    static let shared = AudioManager()
    private var player: AVAudioPlayer?
    private var currentTrackName: String?
    
    private init() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback, mode: .default)
        try? session.setActive(true)
    }
    
    func playFullSoundtrack() {
        play(name: "som", volume: 0.8, loop: true)
    }
    
    func playGameplayLoop() {
        // Se já estiver tocando 'meio', não faz nada.
        // Isso impede que a música resete ao mudar de tela.
        if currentTrackName == "meio" && player?.isPlaying == true { return }
        play(name: "meio", volume: 0.4, loop: true)
    }
    
    func playVictoryTheme() {
        play(name: "final", volume: 0.8, loop: false)
    }
    
    // Função de fade opcional, mas vamos evitar usar na transição da Mari
    func fadeOutAndStop() {
        player?.setVolume(0, fadeDuration: 1.0)
        currentTrackName = nil
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            player?.stop()
        }
    }
    
    private func play(name: String, volume: Float, loop: Bool) {
        player?.stop() // Para IMEDIATAMENTE a anterior
        guard let asset = NSDataAsset(name: name) else { return }
        do {
            player = try AVAudioPlayer(data: asset.data)
            player?.numberOfLoops = loop ? -1 : 0
            player?.volume = volume
            player?.prepareToPlay()
            player?.play()
            currentTrackName = name
        } catch { print("Erro som") }
    }
}
