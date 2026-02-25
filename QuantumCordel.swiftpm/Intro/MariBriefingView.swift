import SwiftUI

// --- 2. MARI BRIEFING VIEW ---
struct MariBriefingView: View {
    var onComplete: () -> Void
    @State private var showMari = false
    @State private var showText = false
    @State private var showButton = false
    @State private var displayedText = ""
    
    @State private var isTyping = false
    
    let fullText = """
    The world you see is plain and wide,
    With straight lines on every side.
    But deep inside the atom's core,
    It's waves and vectors, nothing more.
    I'll teach you how to steer and glide,
    Upon this strange and quantum tide. 
    """
    
    var body: some View {
        ZStack {
            ZStack {
                Image("sertaobg").resizable().scaledToFill().edgesIgnoringSafeArea(.all).opacity(0.1)
                
                VStack(spacing: 25) {
                    ZStack {
                        if showMari {
                            Circle().stroke(AngularGradient(colors: [.xiloMagenta, .clear, .xiloMagenta], center: .center), lineWidth: 3)
                                .frame(width: 250, height: 250)
                                .rotationEffect(.degrees(showText ? 360 : 0))
                                .animation(.linear(duration: 10).repeatForever(autoreverses: false), value: showText)
                        }
                        Image("Mari").resizable().scaledToFit().clipShape(Circle()).frame(width: 420, height: 420)
                            .overlay(Circle().stroke(Color.xiloMagenta.opacity(0.8), lineWidth: 2))
                            .scaleEffect(showMari ? 1 : 0.5).opacity(showMari ? 1 : 0)
                    }
                    
                    Text("I'm Mariana")
                        .font(.system(size: 35, weight: .bold, design: .monospaced))
                        .foregroundColor(.xiloMagenta)
                        .opacity(showMari ? 1 : 0)
                    
                    VStack {
                        Text(displayedText)
                            .font(.system(size: 27, weight: .medium, design: .serif))
                            .italic()
                            .lineSpacing(6)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, minHeight: 180)
                    }
                    .padding(25)
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .padding(.horizontal, 20)
                    .opacity(showMari ? 1 : 0)
                    
                    if showButton {
                        Button(action: {
                            TechSound.play(.click)
                            onComplete()
                        }) {
                            HStack {
                                Text("UNDERSTAND VECTORS")
                                Image(systemName: "arrow.up.forward.circle.fill")
                            }
                            .font(.headline.bold())
                            .foregroundColor(.xiloBlack)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 30)
                            .background(Color.xiloCyan)
                            .cornerRadius(12)
                        }
                        .transition(.scale)
                    } else {
                        Spacer().frame(height: 60)
                    }
                }
                .padding()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if isTyping {
                    skipTypewriter()
                }
            }
        }
        .onAppear {
            Task {
                await AudioManager.shared.playGameplayLoop()
                await animateEntrance()
            }
        }
    }
    
    //MARK: - Animation Logic
    
    func animateEntrance() async {
        TechSound.play(.staticNoise)
        withAnimation(.spring()) { showMari = true }
        try? await Task.sleep(nanoseconds: 500_000_000)
        showText = true
        await typeWriterEffect()
    }
    
    func typeWriterEffect() async {
        isTyping = true
        let chars = Array(fullText)
        displayedText = ""
        for char in chars {

            guard isTyping else { return }
            
            try? await Task.sleep(nanoseconds: 70_000_000)
            displayedText.append(char)
        }
        isTyping = false
        withAnimation { showButton = true }
    }
    
    func skipTypewriter() {
        isTyping = false
        displayedText = fullText
        withAnimation { showButton = true }
    }
}
