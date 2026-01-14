import SwiftUI

struct VictoryView: View {
    var onRestart: () -> Void
    @State private var showElements = false
    
    var body: some View {
        ZStack {
            // Fundo com opacidade controlada
            Image("victorybg")
                .resizable()
                .scaledToFill()
                .opacity(0.07)
                .edgesIgnoringSafeArea(.all)
                .overlay(Color.xiloBlack.opacity(0.3))
            
            VStack(spacing: 25) {
                // Selo de check com entrada suave
                if showElements {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.xiloYellow)
                        .shadow(color: .xiloYellow, radius: 10)
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .scale),
                            removal: .opacity
                        ))
                }
                
                // Avatar da Mari com brilho
                ZStack {
                    Circle()
                        .fill(Color.xiloCyan.opacity(0.1))
                        .frame(width: 180, height: 180)
                    
                    Image("Mari")
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 160, height: 160)
                        .overlay(Circle().stroke(Color.xiloCyan, style: StrokeStyle(lineWidth: 4, dash: [7])))
                        .shadow(color: .xiloCyan, radius: 12)
                }
                .opacity(showElements ? 1 : 0)
                .offset(y: showElements ? 0 : 20) // Desliza levemente para cima
                
                // Título principal
                Text("QUANTUM MASTERED")
                    .font(.largeTitle.bold())
                    .foregroundColor(.xiloCyan)
                    .opacity(showElements ? 1 : 0)
                
                // Bloco do Poema (Texto final)
                VStack(spacing: 8) {
                    Text("The spin, the coin, the ghost connection,")
                    Text("You've steered the tide in each direction.")
                    Text("Two states as one, a shared design,")
                    Text("Beyond the grid, the worlds entwine.")
                    Text("The quantum core is yours to command,")
                    Text("With reality's code held in your hand.")
                }
                .font(.system(size: 16, weight: .medium, design: .serif))
                .italic()
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(20)
                .background(Color.xiloBlack.opacity(0.7))
                .cornerRadius(15)
                .opacity(showElements ? 1 : 0)
                .offset(y: showElements ? 0 : 10)
                
                // Botão de Reiniciar
                Button(action: {
                    TechSound.play(.click)
                    onRestart()
                }) {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                        Text("PLAY AGAIN")
                    }
                    .font(.headline.bold())
                    .foregroundColor(.xiloBlack)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 40)
                    .background(Color.xiloCyan)
                    .cornerRadius(12)
                }
                .opacity(showElements ? 1 : 0)
                .scaleEffect(showElements ? 1 : 0.9)
            }
            .padding()
        }
        .onAppear {
            // Toca o som de sucesso imediatamente
            TechSound.play(.success)
            
            // Inicia a música de vitória
            Task {
                await AudioManager.shared.playVictoryTheme()
            }
            
            // Animação SUAVE e LENTA (2 segundos de duração)
            withAnimation(.easeInOut(duration: 2.0).delay(0.5)) {
                showElements = true
            }
        }
    }
}
