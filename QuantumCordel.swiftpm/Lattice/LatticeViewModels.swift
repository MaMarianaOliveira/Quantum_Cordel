import SwiftUI
import Combine

// --- 1. MAIN VIEW MODEL ---
@MainActor
class MainViewModel: ObservableObject {
    @Published var currentState: GameState = .introGlitch
    
    
    func advanceToBriefing() { currentState = .mariBriefing }
    func advanceToTutorial() { currentState = .tutorial }
    func advanceToEntangled() { currentState = .entangled}
    func advanceToChallenge() { currentState = .challenge }
    func advanceToVictory() { currentState = .victory }
    func resetGame() { currentState = .introGlitch }
}

// --- 2. GAME VIEW MODEL ---
@MainActor
class LatticeViewModels: ObservableObject {
    @Published var currentPos: GridPoint
    @Published var shadowPos: GridPoint
    @Published var showHint: Bool = false
    @Published var isLevelComplete: Bool = false
    
    let config: LevelConfig
    let onComplete: () -> Void
    private var hintTimer: Timer?
    
    init(config: LevelConfig, onComplete: @escaping () -> Void) {
        self.config = config
        self.onComplete = onComplete
        self.currentPos = GridPoint(i: 0, j: 0)
        self.shadowPos = config.shadowStart
        self.showHint = false
        startHintTimer()
    }
    
    func startHintTimer() {
        hintTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                if !self.checkWinCondition() {
                    withAnimation { self.showHint = true }
                    TechSound.play(.glitch)
                }
            }
        }
    }
    
    // --- FUNÇÃO SUBSTITUÍDA COM LIMITAÇÃO DE GRADE ---
    func move(di: Int, dj: Int) {
            let nextMariI = currentPos.i + di
            let nextMariJ = currentPos.j + dj
            
            var nextShadowI = shadowPos.i
            var nextShadowJ = shadowPos.j
            
            if config.isEntangled {
                nextShadowI -= di
                nextShadowJ -= dj
            }
            
            // Limites da grade visual (do centro 0 até as bordas -2 e 2)
            let limit = 2
            
            let mariInBounds = nextMariI >= -limit && nextMariI <= limit &&
                               nextMariJ >= -limit && nextMariJ <= limit
            
            let shadowInBounds = nextShadowI >= -limit && nextShadowI <= limit &&
                                 nextShadowJ >= -limit && nextShadowJ <= limit
            
            if mariInBounds && shadowInBounds {
                // Usamos animação para o movimento ser visível entrando no círculo
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    currentPos.i = nextMariI
                    currentPos.j = nextMariJ
                    shadowPos.i = nextShadowI
                    shadowPos.j = nextShadowJ
                }
                
                TechSound.play(.move)
                
                // Verificação de vitória imediata após o movimento
                if checkWinCondition() {
                    finishLevel()
                }
            } else {
                TechSound.play(.error)
            }
        }
    private func checkWinCondition() -> Bool {
        let mariWin = (currentPos == config.target)
        if config.isEntangled {
            let shadowWin = (shadowPos == config.shadowTarget)
            return mariWin && shadowWin
        } else {
            return mariWin
        }
    }
    
    func applyHint() {
        var di = 0; var dj = 0
        if currentPos.i < config.target.i { di = 1 }
        else if currentPos.i > config.target.i { di = -1 }
        else if currentPos.j < config.target.j { dj = 1 }
        else if currentPos.j > config.target.j { dj = -1 }
        move(di: di, dj: dj)
    }
    
    private func finishLevel() {
            hintTimer?.invalidate()
            withAnimation {
                showHint = false
                isLevelComplete = true // Ativa o balão de encerramento
            }
            TechSound.play(.success)
            
            // Aumentamos o tempo para 3 segundos para dar tempo de ler o balão
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                self.onComplete()
            }
        }
    }
