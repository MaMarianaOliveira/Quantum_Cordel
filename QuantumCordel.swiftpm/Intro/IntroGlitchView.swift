import SwiftUI
import AVFoundation

struct IntroGlitchView: View {
    var onComplete: () -> Void
    @State private var glitchOffset: CGFloat = 0
    @State private var isVisible = false
    @State private var showButton = false
    
    // Estados para o aviso de orientação
    @State private var showOrientationNotice = true
    @State private var rotationDegree: Double = 90
    
    var body: some View {
        ZStack {
            // FUNDO PADRÃO
            Image("transmissionbg").resizable().scaledToFill().edgesIgnoringSafeArea(.all).opacity(0.15)
            Color.xiloBlack.opacity(0.8).edgesIgnoringSafeArea(.all)
            
            // 1. CONTEÚDO PRINCIPAL
            VStack(spacing: 30) {
                Image(systemName: "atom")
                    .font(.system(size: 80)).foregroundColor(.xiloCyan)
                    .offset(x: glitchOffset).opacity(isVisible ? 1 : 0)
                    .shadow(color: .xiloCyan.opacity(0.5), radius: 10)
                
                Text("PQC DEFENSE INITIALIZING...\nORIGIN: BRAZIL - PERNAMBUCO, 2026")
                    .font(.system(.title2, design: .monospaced)).multilineTextAlignment(.center)
                    .foregroundColor(.xiloCyan).shadow(color: .xiloCyan, radius: 5)
                    .offset(x: -glitchOffset)
                
                Text("LOADING MODULES: QUANTUM THREAT & KYBER LATTICE")
                    .font(.system(size: 14, weight: .medium, design: .monospaced))
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.top, 5)
                
                if showButton {
                    Button(action: {
                        TechSound.play(.success)
                        onComplete()
                    }) {
                        Text("START SIMULATION")
                            .font(.headline.bold()).foregroundColor(.xiloBlack).padding()
                            .background(Color.xiloCyan).cornerRadius(8)
                    }
                    .transition(.scale)
                }
            }
            .blur(radius: showOrientationNotice ? 20 : 0)
            .opacity(showOrientationNotice ? 0 : 1)
            
            // 2. OVERLAY DE ORIENTAÇÃO
            if showOrientationNotice {
                ZStack {
                    Color.xiloBlack.edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 35) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.xiloCyan, lineWidth: 4)
                                .frame(width: 100, height: 150)
                                .rotationEffect(.degrees(rotationDegree))
                            
                            Image(systemName: "arrow.counterclockwise")
                                .font(.title.bold())
                                .foregroundColor(.xiloCyan)
                        }
                        .onAppear {
                            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: false)) {
                                rotationDegree = 0
                            }
                        }
                        
                        VStack(spacing: 15) {
                            Text("STABILIZING INTERFACE")
                                .font(.system(size: 22, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                            
                            Text("KEEP THE DEVICE UPRIGHT")
                                .font(.system(size: 14, design: .monospaced))
                                .foregroundColor(.xiloCyan)
                                .opacity(0.8)
                        }
                    }
                }
                .transition(.opacity)
            }
        }
        .onAppear {
            startBootSequence()
        }
    }
    
    // MARK: - Lógica de Inicialização
    
    private func startBootSequence() {
        // A música "som" inicia IMEDIATAMENTE junto com a instrução
        Task {
            await AudioManager.shared.playFullSoundtrack()
        }
        
        // 1. Mantém o aviso por 2.5 segundos
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 1.0)) {
                showOrientationNotice = false
            }
            
            // 2. Após o aviso sumir, inicia o efeito visual de Glitch
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                runOriginalLogic()
            }
        }
    }
    
    private func runOriginalLogic() {
        TechSound.play(.glitch)
        withAnimation(.easeIn(duration: 1.5)) { isVisible = true }
        
        Task {
            // Verifica a duração do áudio para temporizar o botão
            if let asset = NSDataAsset(name: "som") {
                do {
                    let tempPlayer = try AVAudioPlayer(data: asset.data)
                    // O botão aparece após 20% da música
                    let nanoseconds = UInt64((tempPlayer.duration * 1_000_000_000) * 0.2)
                    try await Task.sleep(nanoseconds: nanoseconds)
                } catch {
                    try? await Task.sleep(nanoseconds: 3_000_000_000)
                }
            } else {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
            }
            
            withAnimation(.spring()) { showButton = true }
        }
    }
}
