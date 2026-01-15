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
                MariBriefingView(onComplete: { mainVM.advanceToTutorial()  })
                
            case .tutorial:
                QuantumThreatView(onComplete: { mainVM.advanceToEntangled() })
                
            case .entangled:
                            // MUDANÇA: Usando o novo LatticeBriefingView em vez de EntangledIntroductionView
                            LatticeBriefingView(onNext: { mainVM.advanceToChallenge() })
                
            case .challenge:
                // FASE 2: KYBER / LATTICE (Antigo Entangled)
                let latticeConfig = LevelConfig(
                    title: "PROTOCOL: KYBER LATTICE",
                    instruction: "Navigate the complex Grid. Align Mari & Shadow to generate the PQ3 Key.",
                    basis1: Vector(x: 50, y: 0),
                    basis2: Vector(x: 0, y: 50),
                    target: GridPoint(i: 2, j: 2),
                    isEntangled: true,
                    shadowTarget: GridPoint(i: -2, j: -2),
                    shadowStart: GridPoint(i: 0, j: 0),
                    bgImageName: "phase2bg",
                    themeColor: .xiloMagenta
                )
                
                LatticeView(
                    viewModel: LatticeViewModels(config: latticeConfig, onComplete: {
                        mainVM.advanceToVictory()
                    })
                )
                
            case .victory:
                VictoryView {mainVM.resetGame() }
            }
        }
        .preferredColorScheme(.dark)
        .statusBar(hidden: true)
    }
}
