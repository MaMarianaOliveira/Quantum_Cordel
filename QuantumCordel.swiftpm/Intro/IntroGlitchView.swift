//
//  SwiftUIView.swift
//  QuantumCordel
//
//  Created by mcro on 09/01/26.
//

import SwiftUI

struct IntroGlitchView: View {
    var onComplete: () -> Void
    @State private var glitchOffset: CGFloat = 0
    @State private var isVisible = false
    @State private var showButton = false
    
    var body: some View {
        ZStack {
            Image("transmissionbg").resizable().scaledToFill().edgesIgnoringSafeArea(.all).opacity(0.15)
            Color.xiloBlack.opacity(0.6).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Image(systemName: "atom")
                    .font(.system(size: 80)).foregroundColor(.xiloCyan)
                    .offset(x: glitchOffset).opacity(isVisible ? 1 : 0)
                
                Text("QUANTUM SYSTEM INITIALIZING...\nORIGIN: PERNAMBUCO, 2026")
                    .font(.system(.title2, design: .monospaced)).multilineTextAlignment(.center)
                    .foregroundColor(.xiloCyan).shadow(color: .xiloCyan, radius: 5)
                    .offset(x: -glitchOffset)
                Text("LEARNING MODULES: SUPERPOSITION & ENTANGLEMENT")
                                        .font(.system(size: 14, weight: .medium, design: .monospaced))
                                        .foregroundColor(.white.opacity(0.7))
                                        .padding(.top, 5)
                
                if showButton {
                    Button(action: {
                        TechSound.play(.success)
                        // CORREÇÃO AQUI: Task e await necessários para actors
                        onComplete()
                    }) {
                        Text("START QUANTUM JOURNEY")
                            .font(.headline.bold()).foregroundColor(.xiloBlack).padding()
                            .background(Color.xiloCyan).cornerRadius(8)
                    }
                    .transition(.scale)
                }
            }
        }
        .onAppear {
            TechSound.play(.glitch)
            withAnimation(.easeIn(duration: 1.5)) { isVisible = true }
            // CORREÇÃO: Chamada assíncrona
            Task { await AudioManager.shared.playFullSoundtrack() }
            
            Task {
                try? await Task.sleep(nanoseconds: 12_500_000_000)
                withAnimation(.spring()) { showButton = true }
            }
        }
    }
}
