import SwiftUI

struct LatticeBriefingView: View {
    var onNext: () -> Void
    @State private var showMari = false
    @State private var showText = false
    @State private var showButton = false
    @State private var displayedText = ""
    
    @State private var isTyping = false
    
    let cordelText = """
    The old keys broke, the lock is gone,
    But a new defense is being drawn.
    A Lattice Grid, a complex space,
    Where Quantum power loses the race.
    
    It's a maze of math, a vector trap,
    To hide our data on the map.
    Align the shadows, find the way,
    And Kyber's Shield will save the day.
    """
    
    var body: some View {
        ZStack {
            ZStack {
                Image("kyber")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.15)
                    .overlay(Color.xiloBlack.opacity(0.6))
                
                VStack(spacing: 25) {
                    ZStack {
                        if showMari {
                            Circle().stroke(AngularGradient(colors: [.xiloMagenta, .clear, .xiloMagenta], center: .center), lineWidth: 3)
                                .frame(width: 220, height: 220)
                                .rotationEffect(.degrees(showText ? 360 : 0))
                                .animation(.linear(duration: 10).repeatForever(autoreverses: false), value: showText)
                        }
                        Image("Mari")
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 200, height: 200)
                            .overlay(Circle().stroke(Color.xiloMagenta.opacity(0.8), lineWidth: 2))
                            .scaleEffect(showMari ? 1 : 0.5)
                            .opacity(showMari ? 1 : 0)
                    }
                    
                    Text("Defense Protocol: Kyber")
                        .font(.system(size: 35, weight: .bold, design: .monospaced))
                        .foregroundColor(.xiloMagenta)
                        .opacity(showMari ? 1 : 0)
                    
                    VStack {
                        Text(displayedText)
                            .font(.system(size: 20, weight: .medium, design: .serif))
                            .italic()
                            .lineSpacing(6)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: 340, minHeight: 200, alignment: .leading)
                    }
                    .padding(25)
                    .background(Color.xiloBlack.opacity(0.9))
                    .cornerRadius(20)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.xiloMagenta.opacity(0.3), lineWidth: 1))
                    .opacity(showMari ? 1 : 0)
                    
                    if showButton {
                        Button(action: {
                            TechSound.play(.click)
                            onNext()
                        }) {
                            HStack {
                                Text("ENTER THE LATTICE")
                                Image(systemName: "grid")
                            }
                            .font(.headline.bold())
                            .foregroundColor(.xiloBlack)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 30)
                            .background(Color.xiloMagenta)
                            .cornerRadius(12)
                            .shadow(color: .xiloMagenta.opacity(0.5), radius: 10)
                        }
                        .transition(.scale.combined(with: .opacity))
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
    
    // MARK: - Logic
    
    func animateEntrance() async {
        TechSound.play(.staticNoise)
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) { showMari = true }
        try? await Task.sleep(nanoseconds: 600_000_000)
        showText = true
        await typeWriterEffect()
    }
    
    func typeWriterEffect() async {
        isTyping = true
        let chars = Array(cordelText)
        displayedText = ""
        for char in chars {
            guard isTyping else { return }
            try? await Task.sleep(nanoseconds: 35_000_000)
            displayedText.append(char)
        }
        isTyping = false
        withAnimation(.easeIn(duration: 0.5)) { showButton = true }
    }
    
    func skipTypewriter() {
        isTyping = false
        displayedText = cordelText
        withAnimation { showButton = true }
    }
}
