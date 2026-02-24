import SwiftUI

struct VictoryView: View {
    var onRestart: () -> Void
    @State private var showElements = false
    
    var body: some View {
        ZStack {
            Image("victorybg").resizable().scaledToFill().opacity(0.07)
                .edgesIgnoringSafeArea(.all).overlay(Color.xiloBlack.opacity(0.3))
                .accessibilityHidden(true)
            
            VStack(spacing: 25) {
                if showElements {
                    Image(systemName: "shield.check.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.xiloCyan)
                        .shadow(color: .xiloCyan, radius: 10)
                        .transition(.scale)
                        .accessibilityLabel("Quantum Atom Icon")
                       .accessibilityAddTraits(.isImage)
                }
                
                ZStack {
                    Circle().fill(Color.xiloCyan.opacity(0.1)).frame(width: 420, height: 420)
                    Image("Mari").resizable().scaledToFit().clipShape(Circle()).frame(width: 400, height: 400)
                        .overlay(Circle().stroke(Color.xiloCyan, style: StrokeStyle(lineWidth: 4, dash: [7])))
                        .shadow(color: .xiloCyan, radius: 12)
                }
                .opacity(showElements ? 1 : 0).offset(y: showElements ? 0 : 20)
                
                Text("PQ3 DEFENSE ESTABLISHED")
                    .font(.largeTitle.bold())
                    .foregroundColor(.xiloCyan)
                    .opacity(showElements ? 1 : 0)
                
            
                VStack(spacing: 8) {
                    Text("The harvest tried, but could not break,")
                    
              
                    Text("The lattice shield no force can shake.")
                    
                    Text("Through vectors grid and error's might,")
                    Text("We keep the data safe tonight.")
                    Text("Quantum power is strong and vast,")
                    Text("But Math ensures our secrets last.")
                }
                .font(.system(size: 24, weight: .medium, design: .serif))
                .italic().foregroundColor(.white).multilineTextAlignment(.center).padding(20)
                .background(Color.xiloBlack.opacity(0.7)).cornerRadius(15)
                .opacity(showElements ? 1 : 0).offset(y: showElements ? 0 : 10)
                
                Button(action: { TechSound.play(.click); onRestart() }) {
                    HStack { Image(systemName: "arrow.counterclockwise"); Text("RESTART SYSTEM") }
                        .font(.headline.bold()).foregroundColor(.xiloBlack).padding(.vertical, 16).padding(.horizontal, 40)
                        .background(Color.xiloCyan).cornerRadius(12)
                }
                .opacity(showElements ? 1 : 0).scaleEffect(showElements ? 1 : 0.9)
            }
            .padding()
        }
        .onAppear {
            TechSound.play(.success)
            Task { await AudioManager.shared.playVictoryTheme() }
            withAnimation(.easeInOut(duration: 2.0).delay(0.5)) { showElements = true }
        }
    }
}
