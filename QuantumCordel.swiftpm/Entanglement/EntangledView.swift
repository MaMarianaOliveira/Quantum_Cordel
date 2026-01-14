import SwiftUI

struct EntangledView: View {
    @StateObject var viewModel: EntagledViewModels
    @State private var tutorialStep = 0
    
    // Espaçamento para a grade ocupar o quadrado de 350px
    let gridSpacing: CGFloat = 75

    var body: some View {
        ZStack {
            // Fundo
            Image("phase2bg").resizable().scaledToFill().opacity(0.1)
                .edgesIgnoringSafeArea(.all)
                .overlay(Color.xiloBlack.opacity(0.6))
            
            VStack(spacing: 0) {
                // 1. Cabeçalho
                VStack(spacing: 4) {
                    Text("PHASE 2: ENTANGLED")
                        .font(.system(size: 22, weight: .black, design: .monospaced))
                        .foregroundColor(.xiloMagenta)
                    Text("SPOOKY ACTION AT A DISTANCE")
                        .font(.system(size: 14, weight: .bold)).italic().foregroundColor(.white.opacity(0.7))
                }
                .padding(.top, 50)
                
                Spacer()

                // 2. ÁREA DO JOGO (Destaque no Quadrado Roxo)
                ZStack {
                    // O Quadrado Roxo (Grade)
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.xiloMagenta.opacity(0.8), lineWidth: 3)
                        .frame(width: 350, height: 350)
                        .background(Color.xiloBlack.opacity(0.4).cornerRadius(20))
                    
                    // Portais (Alvos nos Cantos)
                    PortalView(color: .xiloCyan, size: 70)
                        .offset(x: CGFloat(viewModel.config.target.j) * gridSpacing,
                                y: CGFloat(viewModel.config.target.i) * gridSpacing)
                    
                    PortalView(color: .xiloMagenta, size: 70)
                        .offset(x: CGFloat(viewModel.config.shadowTarget.j) * gridSpacing,
                                y: CGFloat(viewModel.config.shadowTarget.i) * gridSpacing)
                    
                    // Mari (Principal)
                    Image("Mari")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 65, height: 65)
                        .shadow(color: .xiloCyan, radius: 10)
                        .offset(x: CGFloat(viewModel.currentPos.j) * gridSpacing,
                                y: CGFloat(viewModel.currentPos.i) * gridSpacing)
                    
                    // Mari_2 (Sombra)
                    Image("Mari_2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 65, height: 65)
                        .opacity(0.9)
                        .shadow(color: .xiloMagenta, radius: 10)
                        .offset(x: CGFloat(viewModel.shadowPos.j) * gridSpacing,
                                y: CGFloat(viewModel.shadowPos.i) * gridSpacing)
                }
                .frame(width: 350, height: 350)
                
                Spacer()

                // 3. Guia da Mari Compacto
                mariGuideComponent
                
                // 4. Controles (Setas)
                controlsComponent
                    .padding(.bottom, 40)
            }
        }
    }
    
    // --- COMPONENTES DE INTERFACE ---
    
    var mariGuideComponent: some View {
        HStack(alignment: .center, spacing: 12) {
            Image("Mari").resizable().scaledToFit().frame(width: 70, height: 70)
                .clipShape(Circle()).overlay(Circle().stroke(Color.xiloMagenta, lineWidth: 2))
            VStack(alignment: .leading) {
                Text(tutorialText).font(.system(size: 14, design: .serif)).foregroundColor(.white).padding(15)
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.xiloBlack.opacity(0.85)))
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.xiloMagenta.opacity(0.5), lineWidth: 1))
            }.frame(width: 260)
        }.padding(.bottom, 20)
    }

    var controlsComponent: some View {
        VStack {
            if tutorialStep < 3 {
                Button("NEXT") {
                    TechSound.play(.click)
                    withAnimation { tutorialStep += 1 }
                }.buttonStyle(XiloButtonStyleEntangled())
            } else {
                HStack(spacing: 20) {
                    ControlButton(icon: "arrow.left") { viewModel.move(di: 0, dj: -1) }
                    VStack(spacing: 20) {
                        ControlButton(icon: "arrow.up") { viewModel.move(di: -1, dj: 0) }
                        ControlButton(icon: "arrow.down") { viewModel.move(di: 1, dj: 0) }
                    }
                    ControlButton(icon: "arrow.right") { viewModel.move(di: 0, dj: 1) }
                }
            }
        }
    }

    var tutorialText: String  {
        if viewModel.isLevelComplete {
            return "Incredible! We overcame the distance. Even separated, we act as one. Entanglement is proof that everything in the universe is connected!"
        }
        switch tutorialStep {
        case 0: return "Look! My shadow and I are entangled by an invisible bond."
        case 1: return "When I move, it reacts instantly, but in reverse!"
        case 2: return "We need to synchronize our steps to reach the portals in the corners."
        case 3: return "Take me to the blue portal and my Shadow to the pink one!"
        default: return ""
        }
    }
}

// --- ESTILOS E SUBVIEWS ---

struct PortalView: View {
    let color: Color
    let size: CGFloat
    var body: some View {
        ZStack {
            Circle().stroke(color, lineWidth: 3).frame(width: size, height: size)
            Circle().fill(color.opacity(0.2)).frame(width: size - 5, height: size - 5)
        }.shadow(color: color, radius: 15)
    }
}

struct ControlButton: View {
    let icon: String
    let action: () -> Void
    var body: some View {
        Button(action: { action() }) {
            Image(systemName: icon)
                .font(.title.bold())
                .foregroundColor(.xiloBlack)
                .frame(width: 60, height: 60)
                .background(Color.xiloMagenta)
                .cornerRadius(12)
        }
    }
}

struct XiloButtonStyleEntangled: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(.xiloBlack)
            .padding(.vertical, 14)
            .frame(maxWidth: 200)
            .background(Color.xiloMagenta)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}
