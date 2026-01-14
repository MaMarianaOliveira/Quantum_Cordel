//
//  SwiftUIView.swift
//  QuantumCordel
//
//  Created by mcro on 09/01/26.
//

import SwiftUI

struct ConceptScreen: View {
    let title: String; let subtitle: String; let description: String; let icon: String; let color: Color; let bgImage: String; let onNext: () -> Void
    @State private var displayedText = ""
    @State private var showButton = false
    
    var body: some View {
        ZStack {
            Image(bgImage).resizable().scaledToFill().edgesIgnoringSafeArea(.all).opacity(0.15)
            Color.xiloBlack.opacity(0.7).edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                Image(systemName: icon).font(.system(size: 70)).foregroundColor(color)
                    .padding().background(Circle().stroke(color, lineWidth: 3))
                VStack(spacing: 10) {
                    Text(title).font(.largeTitle.bold()).foregroundColor(.white)
                    Text(subtitle).font(.headline).foregroundColor(color).italic()
                }
                Text(displayedText).font(.system(size: 18, design: .monospaced)).foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center).padding(25).frame(minHeight: 160)
                    .background(Color.xiloBlack.opacity(0.6)).cornerRadius(15).padding(.horizontal)
                Spacer()
                if showButton {
                    Button(action: { TechSound.play(.click); onNext() }) {
                        HStack { Text("INITIALIZE SIMULATION"); Image(systemName: "arrow.right.circle.fill") }
                            .font(.headline.bold()).foregroundColor(.xiloBlack).padding().frame(maxWidth: .infinity).background(color).cornerRadius(10)
                    }.padding(.horizontal, 40).padding(.bottom, 300)
                } else { Spacer().frame(height: 360) }
            }.padding(.top, 200)
        }
        .onAppear {
            // CORREÇÃO: Task + await para o actor (Música 'meio' não reseta)
            Task {
                await AudioManager.shared.playGameplayLoop()
                await typeWriterEffect()
            }
        }
    }
    
    func typeWriterEffect() async {
        let chars = Array(description)
        displayedText = ""
        try? await Task.sleep(nanoseconds: 500_000_000)
        for char in chars {
            try? await Task.sleep(nanoseconds: 60_000_000)
            displayedText.append(char)
        }
        withAnimation { showButton = true }
    }
}
