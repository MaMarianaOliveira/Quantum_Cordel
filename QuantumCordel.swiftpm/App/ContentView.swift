import SwiftUI

struct ContentView: View {
    @StateObject private var mainVM = MainViewModel()
    
    var body: some View {
        ZStack {
            Color.xiloBlack.edgesIgnoringSafeArea(.all)
            
            switch mainVM.currentState {
            case .introGlitch:
                IntroGlitchView(onComplete: { mainVM.advanceToBriefing() })
                
            case .mariBriefing:
                // Usando a nova MariBriefingView.swift
                MariBriefingView(onComplete: { mainVM.advanceToTutorial()  })
                
                
            case .tutorial:
                SuperpositionCoinView(onComplete: { mainVM.advanceToEntangled() })
                
            case .entangled:
                EntangledIntroductionView(onNext: { mainVM.advanceToChallenge() })
                
            case .challenge:
                // FASE 2: O Grid Emaranhado (Mari & Sombra)
                let entangledConfig = LevelConfig(
                    title: "PHASE 2: ENTANGLED",
                    instruction: "You and your Shadow are entangled. Move to align BOTH on the targets.",
                    basis1: Vector(x: 50, y: 0),
                    basis2: Vector(x: 0, y: 50),
                    target: GridPoint(i: 2, j: 2),
                    isEntangled: true,
                    shadowTarget: GridPoint(i: -2, j: -2),
                    shadowStart: GridPoint(i: 0, j: 0),
                    bgImageName: "phase2bg",
                    themeColor: .xiloMagenta
                )
                
                // Atualizado para o novo nome da classe que você definiu
                EntangledView(
                    viewModel: EntagledViewModels(config: entangledConfig, onComplete: {
                        mainVM.advanceToVictory()
                    })
                )
                
            case .victory:
                // Usando a nova VictoryView.swift com o parâmetro onRestart
                VictoryView {mainVM.resetGame() }
            }
        }
        .preferredColorScheme(.dark)
        .statusBar(hidden: true)
    }
}
