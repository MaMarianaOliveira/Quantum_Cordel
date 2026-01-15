import SwiftUI

struct LatticeView: View {
    @StateObject var viewModel: LatticeViewModels
    @State private var tutorialStep = 0
    
    let gridSpacing: CGFloat = 75

    var body: some View {
        ZStack {
            // Fundo
            Image("phase2bg").resizable().scaledToFill().opacity(0.1)
                .edgesIgnoringSafeArea(.all)
                .overlay(Color.xiloBlack.opacity(0.6))
                .accessibilityHidden(true)
            
            VStack(spacing: 0) {
                // 1. Cabeçalho
                VStack(spacing: 4) {
                    Text("DEFENSE: THE LATTICE")
                        .font(.system(size: 30, weight: .black, design: .monospaced))
                        .foregroundColor(.xiloMagenta)
                    Text("FORGING THE PQ3 SHIELD")
                        .font(.system(size: 20, weight: .bold)).italic().foregroundColor(.white.opacity(0.7))
                }
                .padding(.top, 80)
                
                Spacer()

                // 2. ÁREA DO JOGO (Grid Lattice)
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.xiloMagenta.opacity(0.8), lineWidth: 3)
                        .frame(width: 350, height: 350)
                        .background(Color.xiloBlack.opacity(0.4).cornerRadius(20))
                        // Visual Grid Overlay
                        .overlay(
                            Path { path in
                                for i in 1...4 {
                                    let x = CGFloat(i) * (350/5)
                                    path.move(to: CGPoint(x: x, y: 0)); path.addLine(to: CGPoint(x: x, y: 350))
                                    path.move(to: CGPoint(x: 0, y: x)); path.addLine(to: CGPoint(x: 350, y: x))
                                }
                            }.stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                    
                    // Portais (Alvos)
                    PortalView(color: .xiloCyan, size: 70)
                        .offset(x: CGFloat(viewModel.config.target.j) * gridSpacing,
                                y: CGFloat(viewModel.config.target.i) * gridSpacing)
                    
                    PortalView(color: .xiloMagenta, size: 70)
                        .offset(x: CGFloat(viewModel.config.shadowTarget.j) * gridSpacing,
                                y: CGFloat(viewModel.config.shadowTarget.i) * gridSpacing)
                    
                    // Personagens
                    Image("Mari")
                        .resizable().scaledToFit().frame(width: 65, height: 65)
                        .shadow(color: .xiloCyan, radius: 10)
                        .offset(x: CGFloat(viewModel.currentPos.j) * gridSpacing,
                                y: CGFloat(viewModel.currentPos.i) * gridSpacing)
                    
                    Image("Mari_2") // Sombra
                        .resizable().scaledToFit().frame(width: 65, height: 65)
                        .opacity(0.9)
                        .shadow(color: .xiloMagenta, radius: 10)
                        .offset(x: CGFloat(viewModel.shadowPos.j) * gridSpacing,
                                y: CGFloat(viewModel.shadowPos.i) * gridSpacing)
                }
                .frame(width: 350, height: 350)
                
                Spacer()
                
                // Guia Narrativo (Atualizado)
                mariGuideComponent
                
                // Controles
                controlsComponent
                    .padding(.bottom, 40)
            }
        }
    }
    
    // --- COMPONENTES ---
    
    var mariGuideComponent: some View {
        HStack(alignment: .center, spacing: 15) {
            Image("Mari").resizable().scaledToFit().frame(width: 150, height: 150)
                .clipShape(Circle()).overlay(Circle().stroke(Color.xiloMagenta, lineWidth: 2))
            
            VStack(alignment: .leading) {
                Text(tutorialText)
                    .font(.system(size: 30, weight: .medium, design: .serif)) // Fonte 30
                    .foregroundColor(.white)
                    .lineSpacing(3)
                    // Configuração da Caixa Expansível
                    .frame(width: 500) // Largura fixa
                    .frame(minHeight: 18, alignment: .topLeading) // Altura mínima flexível
                    .padding(20)
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.xiloBlack.opacity(0.85)))
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.xiloMagenta.opacity(0.5), lineWidth: 1))
                    .animation(.easeInOut, value: tutorialText)
            }
        }.padding(.bottom, 20)
    }

    var controlsComponent: some View {
            VStack {
                if tutorialStep < 3 {
                    Button("ANALYZE LATTICE") {
                        TechSound.play(.click)
                        withAnimation { tutorialStep += 1 }
                    }
                    .buttonStyle(XiloButtonStyleEntangled())
                    .accessibilityLabel("Analyze the Lattice Grid") // DICA 1
                    .accessibilityHint("Starts the synchronization puzzle") // DICA 2
                } else {
                    HStack(spacing: 20) {
                        ControlButton(icon: "arrow.left") { viewModel.move(di: 0, dj: -1) }
                            .accessibilityLabel("Move Left") // DICA 3: Rótulos claros
                        
                        VStack(spacing: 20) {
                            ControlButton(icon: "arrow.up") { viewModel.move(di: -1, dj: 0) }
                                .accessibilityLabel("Move Up")
                            
                            ControlButton(icon: "arrow.down") { viewModel.move(di: 1, dj: 0) }
                                .accessibilityLabel("Move Down")
                        }
                        
                        ControlButton(icon: "arrow.right") { viewModel.move(di: 0, dj: 1) }
                            .accessibilityLabel("Move Right")
                    }
                }
            }
        }

    // --- ROTEIRO ---
    var tutorialText: String  {
        if viewModel.isLevelComplete {
            return "PERFECT ALIGNMENT! We have woven the vectors into a complex shield. The data is now encased in PQ3, safe from any Quantum attack."
        }
        switch tutorialStep {
        case 0:
            return "Welcome to the Lattice. This geometric grid is the mathematical foundation of Apple's PQ3 encryption, used to protect your messages on iPhone and iPad."
        case 1:
            return "To lock the shield, we need symmetry. You are connected to your Shadow—two parts of the same cryptographic key."
        case 2:
            return "Watch out: The connection is inverted! If you move Left, the Shadow moves Right. We must coordinate to survive."
        case 3:
            return "Guide both avatars to the Portals simultaneously. Once aligned, the Kyber Key is forged and the defense is active!"
        default: return ""
        }
    }
}

// --- SUB-VIEWS E ESTILOS ---

struct PortalView: View {
    let color: Color
    let size: CGFloat
    var body: some View {
        ZStack {
            Circle().stroke(color, lineWidth: 3).frame(width: size, height: size)
            Circle().fill(color.opacity(0.2)).frame(width: size - 5, height: size - 5)
            // Efeito de pulsação simples
            Circle().stroke(color.opacity(0.5), lineWidth: 1)
                .frame(width: size * 0.7, height: size * 0.7)
        }.shadow(color: color, radius: 10)
    }
}

struct ControlButton: View {
    let icon: String
    let action: () -> Void
    var body: some View {
        Button(action: {
            // Feedback tátil simples (opcional) e sonoro
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            action()
        }) {
            Image(systemName: icon)
                .font(.title.bold())
                .foregroundColor(.xiloBlack)
                .frame(width: 60, height: 60)
                .background(Color.xiloMagenta)
                .cornerRadius(12)
                .shadow(color: .xiloMagenta.opacity(0.4), radius: 5, x: 0, y: 3)
        }
    }
}

struct XiloButtonStyleEntangled: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(.xiloBlack)
            .padding(.vertical, 14)
            .frame(maxWidth: 200)
            .background(Color.xiloMagenta)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .shadow(color: .xiloMagenta.opacity(0.3), radius: 5)
    }
}
