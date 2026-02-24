import SwiftUI

struct QuantumThreatView: View {
    var onComplete: () -> Void
    
    @State private var isSpinning = true
    @State private var currentFace = "lock.rotation" // Começa girando/processando
    @State private var rotationDegree = 0.0
    @State private var isQuantumAttack = false
    @State private var isLevelComplete = false
    @State private var tutorialStep = 0
    @State private var lockColor = Color.white
    
    // Timer para animação de rotação
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Fundo
            Image("phase1bg").resizable().scaledToFill().opacity(0.1)
                .edgesIgnoringSafeArea(.all)
                .overlay(Color.xiloBlack.opacity(0.6))
            
            VStack(spacing: 0) {
                // 1. Cabeçalho
                VStack(spacing: 4) {
                    Text("THREAT: QUANTUM INVASION")
                        .font(.system(size: 30, weight: .black, design: .monospaced))
                        .foregroundColor(.xiloCyan)
                    Text("CLASSICAL vs QUANTUM DECRYPTION")
                        .font(.system(size: 20, weight: .bold)).italic().foregroundColor(.white.opacity(0.7))
                }
                .padding(.top, 80)
                
                Spacer()

                // 2. O CADEADO (Alvo)
                ZStack {
                    // Aura de fundo
                    Circle()
                        .fill(RadialGradient(colors: [lockColor.opacity(0.3), .clear], center: .center, startRadius: 50, endRadius: 150))
                        .frame(width: 250, height: 250)
                    
                    // Ícone Principal
                    Image(systemName: currentFace)
                        .font(.system(size: 100))
                        .foregroundColor(lockColor)
                        .rotationEffect(.degrees(rotationDegree))
                        .scaleEffect(isQuantumAttack ? 1.2 : 1.0)
                        .animation(.spring(), value: isQuantumAttack)
                        .accessibilityLabel(isQuantumAttack ? "Broken Lock" : "Secure Lock")
                        .accessibilityValue(isSpinning ? "Processing simulation" : "Status static")
                        
                }
                .onReceive(timer) { _ in
                    if isSpinning {
                        rotationDegree += 10
                    }
                }
                
                Spacer()

                // 3. DIALOGO MARI (CORRIGIDO)
                                HStack(alignment: .center, spacing: 15) {
                                    Image("Mari")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150, height: 150)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.xiloCyan, lineWidth: 2))
                                    
                                    VStack(alignment: .leading) {
                                        Text(tutorialText)
                                            .font(.system(size: 30, weight: .medium, design: .serif))
                                            .foregroundColor(.white)
                                            .lineSpacing(3)
                                            // O frame define o tamanho da caixa
                                            .frame(width: 500) // 1. Define a largura fixa primeiro
                                            .frame(minHeight: 18, alignment: .topLeading) // 2. Define a altura mínima depois
                                            .padding(10) // Espaço interno do texto
                                            // O background vem DEPOIS do frame para preencher todo o tamanho
                                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.xiloBlack.opacity(0.9)))
                                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.xiloCyan.opacity(0.6), lineWidth: 1.5))
                                            .animation(.easeInOut, value: tutorialText)
                                    }
                                }
                                .padding(.bottom, 20)
                // 4. CONTROLES
                VStack(spacing: 12) {
                    
                    // Passo 0: Introdução
                    if tutorialStep == 0 {
                        Button("INITIALIZE TEST") {
                            TechSound.play(.click)
                            withAnimation { tutorialStep = 1 }
                        }.buttonStyle(XiloButtonStyleCompact())
                    }
                    
                    // Passo 1: Ataque Clássico (Vai falhar/Resistir)
                    else if tutorialStep == 1 {
                        Button(action: runClassicalAttack) {
                            HStack {
                                Image(systemName: "laptopcomputer")
                                Text("RUN CLASSICAL BRUTE-FORCE")
                            }
                        }.buttonStyle(XiloButtonStyleCompact())
                    }
                    
                    // Passo 2: Transição para Quântico
                    else if tutorialStep == 2 {
                        Button(action: {
                            TechSound.play(.click)
                            withAnimation { tutorialStep = 3 }
                        }) {
                            Text("NEXT: THE QUANTUM THREAT")
                        }.buttonStyle(XiloButtonStyleCompact())
                    }
                    
                    // Passo 3: Ataque Quântico (Vai quebrar)
                    else if tutorialStep == 3 {
                        Button(action: runQuantumAttack) {
                            HStack {
                                Image(systemName: "atom")
                                Text("ACTIVATE QUANTUM ATTACK")
                            }
                        }
                        .buttonStyle(XiloButtonStyleDanger()) // Estilo vermelho
                        .accessibilityLabel("Activate Quantum Attack")
                        .accessibilityHint("Simulates Shor's Algorithm breaking the encryption instantly")
                    }
                    
                    // Passo 4: Conclusão
                    else if tutorialStep == 4 {
                        Button(action: {
                            TechSound.play(.success)
                            onComplete()
                        }) {
                            HStack {
                                Text("DEPLOY PQ3 DEFENSE")
                                Image(systemName: "shield.fill")
                            }
                        }.buttonStyle(XiloButtonStyleCompact())
                            
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
    }
    
    // --- LÓGICA DO ROTEIRO ---
    
    var tutorialText: String {
        switch tutorialStep {
        case 0:
            return "This lock represents standard RSA encryption. It protects your messages and bank data today. Let's see how strong it is."
        case 1:
            return "First, let's try to break it with a Classical Supercomputer. It will try to guess the key by brute force."
        case 2:
            return "ACCESS DENIED! See? The lock remained closed. Classical computers would take millions of years to break this math."
        case 3:
            return "But now... let's introduce a Quantum Computer running Shor's Algorithm. It doesn't guess; it calculates the key instantly."
        case 4:
            return "BREACH DETECTED! The lock shattered instantly. 'Harvest Now, Decrypt Later' is a real threat. We need a Lattice Shield!"
        default:
            return ""
        }
    }
    
    func runClassicalAttack() {
        // Simula processamento
        TechSound.play(.move)
        
        // Resultado: RESISTÊNCIA (Cadeado continua fechado)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation {
                isSpinning = false
                rotationDegree = 0
                currentFace = "lock.fill" // Trancado = Sucesso da Defesa
                lockColor = .xiloCyan // Azul = Seguro
                TechSound.play(.success) // Som positivo (defesa funcionou)
                tutorialStep = 2
            }
        }
    }
    
    func runQuantumAttack() {
        // Simula o Glitch/Ataque
        TechSound.play(.glitch)
        isSpinning = true
        isQuantumAttack = true
        lockColor = .xiloMagenta // Rosa/Vermelho = Perigo
        
        // Resultado: QUEBRA (Cadeado abre)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.3)) {
                isSpinning = false
                rotationDegree = 0
                currentFace = "lock.open.fill" // Aberto = Falha da Defesa
                TechSound.play(.error) // Som de alarme
                tutorialStep = 4
            }
        }
    }
}

// --- ESTILOS DE BOTÃO ---

struct XiloButtonStyleCompact: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.bold()).foregroundColor(.xiloBlack).padding()
        .background(Color.xiloCyan).cornerRadius(8)
    }
}

// Botão Vermelho para o Ataque Quântico
struct XiloButtonStyleDanger: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.bold()).foregroundColor(.white).padding()
            .background(Color.red.opacity(0.8)).cornerRadius(8)
            
    }
}
