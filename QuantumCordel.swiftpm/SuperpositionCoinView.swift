import SwiftUI

struct SuperpositionCoinView: View {
    var onComplete: () -> Void
    
    @State private var isSpinning = true
    @State private var currentFace = "sun.max.fill"
    @State private var rotationDegree = 0.0
    @State private var biasActive = false
    @State private var isLevelComplete = false
    @State private var tutorialStep = 0
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Fundo
            Image("phase1bg").resizable().scaledToFill().opacity(0.1)
                .edgesIgnoringSafeArea(.all)
                .overlay(Color.xiloBlack.opacity(0.5))
            
            VStack(spacing: 0) {
                // 1. Cabeçalho (Fixo no topo)
                VStack(spacing: 4) {
                    Text("PHASE 1: SUPERPOSIÇÃO")
                        .font(.system(size: 22, weight: .black, design: .monospaced))
                        .foregroundColor(.xiloCyan)
                    Text("THE COIN PARADOX")
                        .font(.system(size: 14, weight: .bold)).italic().foregroundColor(.white.opacity(0.7))
                }
                .padding(.top, 200)
                
                Spacer()

                // 2. MOEDA GRANDE (Destaque Central)
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: biasActive ? [.xiloCyan, .blue] : [.gray, .white], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 220, height: 220) // Retornada ao tamanho grande
                        .shadow(color: biasActive ? .xiloCyan.opacity(0.6) : .white.opacity(0.2), radius: 25)
                    
                    Image(systemName: currentFace)
                        .font(.system(size: 100))
                        .foregroundColor(biasActive ? .white : .black)
                        .rotation3DEffect(.degrees(rotationDegree), axis: (x: 1, y: 0, z: 0))
                }
                .onReceive(timer) { _ in
                    if isSpinning {
                        rotationDegree += 180
                        currentFace = (currentFace == "sun.max.fill") ? "moon.fill" : "sun.max.fill"
                    }
                }
                
                Spacer()

                // 3. BALÃO DA MARI (Mediano e Organizado)
                HStack(alignment: .center, spacing: 15) {
                    Image("Mari")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75, height: 75)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.xiloCyan, lineWidth: 2))
                    
                    VStack(alignment: .leading) {
                        Text(tutorialText)
                            .font(.system(size: 15, weight: .medium, design: .serif))
                            .foregroundColor(.white)
                            .lineSpacing(3)
                            .padding(15)
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.xiloBlack.opacity(0.9)))
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.xiloCyan.opacity(0.6), lineWidth: 1.5))
                    }
                    .frame(width: 260) // Tamanho mediano fixo para não espalhar
                }
                .padding(.bottom, 20)

                // 4. BOTÕES (Compactos para sobrar espaço para a moeda)
                VStack(spacing: 12) {
                    if tutorialStep == 0 {
                        Button("NEXT") {
                            TechSound.play(.click)
                            withAnimation { tutorialStep = 1 }
                        }.buttonStyle(XiloButtonStyleCompact())
                    } else if !isLevelComplete {
                        Button(action: observeCoin) {
                            HStack {
                                Image(systemName: "eye.fill")
                                Text(isSpinning ? "OBSERVE (MEASURE)" : "TURN AGAIN")
                            }
                        }.buttonStyle(XiloButtonStyleCompact())
                        
                        if (tutorialStep == 2 || tutorialStep == 3) && !biasActive {
                            Button(action: activateBias) {
                                Text("APPLY PROBABILITY VECTOR")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.xiloCyan)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .background(Color.xiloCyan.opacity(0.15))
                                    .cornerRadius(10)
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.xiloCyan.opacity(0.4), lineWidth: 1))
                            }
                        }
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
    }
    
    var tutorialText: String {
        switch tutorialStep {
        case 0: return "Hi! I'm Mari. Look at this coin: it's in Superposition, which means it's both the Sun and the Moon at the same time!"
        case 1: return "Click on OBSERVE to 'collapse' the coin's state. Let's see if you're lucky enough to get Sun."
        case 2: return "Pure luck! The sun came out, but in quantum computing we can't rely on chance. Spin again."
        case 3: return "See? Without control, the coin lands wherever it wants. Apply a Probability Vector to force the Sun!"
        case 4: return "Perfect! The system has now been manipulated. Look at the coin one last time to see the magic!"
        case 5: return "Amazing! With mathematics, we guarantee collapse into the desired state. You have mastered Superposition.!"
        default: return ""
        }
    }
    
    func observeCoin() {
        TechSound.play(.click)
        if isSpinning {
            isSpinning = false
            let resultIsSun = biasActive ? true : Bool.random()
            currentFace = resultIsSun ? "sun.max.fill" : "moon.fill"
            rotationDegree = 0
            if resultIsSun {
                TechSound.play(.success)
                if biasActive {
                    withAnimation { tutorialStep = 5 }; isLevelComplete = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { onComplete() }
                } else { withAnimation { tutorialStep = 2 } }
            } else {
                TechSound.play(.error); withAnimation { tutorialStep = 3 }
            }
        } else { isSpinning = true; if tutorialStep == 2 || tutorialStep == 3 { withAnimation { tutorialStep = 3 } } }
    }
    
    func activateBias() { TechSound.play(.glitch); biasActive = true; withAnimation { tutorialStep = 4 } }
}

struct XiloButtonStyleCompact: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(.xiloBlack)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background(Color.xiloCyan)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}
