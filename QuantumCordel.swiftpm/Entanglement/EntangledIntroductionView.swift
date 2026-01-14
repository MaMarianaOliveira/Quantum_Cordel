import SwiftUI

struct EntangledIntroductionView: View {
    // Recebe a função para ir para a próxima tela (Fase 2: Entrelaçamento)
    var onNext: () -> Void
    
    var body: some View {
        ZStack {
            // Fundo padrão da paleta Xilo
            Color.xiloBlack.edgesIgnoringSafeArea(.all)
            
            // Imagem centralizada do quadrinho (Kyber)
            Image("kyber")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Camada de interface
            VStack {
                Spacer()
                
                Button(action: {
                    // Feedback sonoro de clique
                    TechSound.play(.click)
                    // Avança para o desafio da Sombra (Entrelaçamento)
                    onNext()
                }) {
                    Text("Initialize Simulation")
                        .font(.custom("Courier", size: 20).bold())
                        .padding(.vertical, 16)
                        .padding(.horizontal, 32)
                        .background(Color.xiloMagenta) // Cor temática do Entrelaçamento
                        .foregroundColor(.xiloBlack)
                        .cornerRadius(10)
                        .shadow(color: .xiloMagenta.opacity(0.5), radius: 10)
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            // Mantém a trilha sonora de gameplay (meio) rodando
            Task {
                await AudioManager.shared.playGameplayLoop()
            }
        }
    }
}
