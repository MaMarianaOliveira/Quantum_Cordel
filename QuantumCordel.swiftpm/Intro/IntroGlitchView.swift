import SwiftUI
import AVFoundation // Necessário para ler a duração da música

struct IntroGlitchView: View {
    var onComplete: () -> Void
    @State private var glitchOffset: CGFloat = 0
    @State private var isVisible = false
    @State private var showButton = false
    
    var body: some View {
        ZStack {
            Image("transmissionbg").resizable().scaledToFill().edgesIgnoringSafeArea(.all).opacity(0.15)
            Color.xiloBlack.opacity(0.6).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                // Ícone do Átomo (Visual preferido)
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
        }
        .onAppear {
            TechSound.play(.glitch)
            withAnimation(.easeIn(duration: 1.5)) { isVisible = true }
            
            Task {
                // 1. Começa a tocar a música
                await AudioManager.shared.playFullSoundtrack()
                
                // 2. Calcula a duração exata do arquivo "som"
                if let asset = NSDataAsset(name: "som") {
                    do {
                        // Cria um player temporário apenas para ler a duração (duration property)
                        let tempPlayer = try AVAudioPlayer(data: asset.data)
                        let durationInSeconds = tempPlayer.duration
                        
                        // Converte para nanosegundos para o Task.sleep
                        let nanoseconds = UInt64(durationInSeconds * 1_000_000_000)
                        
                        // Espera a música terminar (ou completar o ciclo)
                        try await Task.sleep(nanoseconds: nanoseconds)
                        
                    } catch {
                        print("Erro ao ler duração do áudio")
                        // Fallback: espera 3 segundos se der erro
                        try? await Task.sleep(nanoseconds: 3_000_000_000)
                    }
                } else {
                    // Fallback se não achar o asset
                    try? await Task.sleep(nanoseconds: 2_000_000_000)
                }
                
                // 3. Libera o botão
                withAnimation(.spring()) { showButton = true }
            }
        }
    }
}
