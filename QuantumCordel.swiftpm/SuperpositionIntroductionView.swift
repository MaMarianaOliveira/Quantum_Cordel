import SwiftUI

struct SuperpositionIntroductionView: View {
    // Recebe a função para ir para a próxima tela (Tutorial/Superposition)
    var onNext: () -> Void
    
    var body: some View {
        ZStack {
            // Fundo padrão da paleta Xilo
            Color.xiloBlack.edgesIgnoringSafeArea(.all)
            
            // Imagem centralizada do quadrinho (HQ/Canva)
            Image("rsa")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Camada de interface sobre a imagem
            VStack {
                Spacer()
                
                Button(action: {
                    // Feedback sonoro de clique
                    TechSound.play(.click)
                    // Avança para o tutorial da Superposição
                    onNext()
                }) {
                    Text("Initialize Simulation")
                        .font(.custom("Courier", size: 20).bold())
                        .padding(.vertical, 16)
                        .padding(.horizontal, 32)
                        .background(Color.xiloCyan) // Cor temática da Superposição
                        .foregroundColor(.xiloBlack)
                        .cornerRadius(10)
                        .shadow(color: .xiloCyan.opacity(0.5), radius: 10)
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            // Garante a continuidade da trilha sonora sem resetar
            Task {
                await AudioManager.shared.playGameplayLoop()
            }
        }
    }
}
