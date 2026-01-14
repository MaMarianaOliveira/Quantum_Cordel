import SwiftUI

// --- 1. EXTENSÕES VISUAIS ---
extension Color {
    static let xiloBlack = Color(red: 0.1, green: 0.1, blue: 0.1)
    static let xiloCyan = Color(red: 0.0, green: 1.0, blue: 1.0)
    static let xiloMagenta = Color(red: 1.0, green: 0.0, blue: 1.0)
    static let xiloYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let xiloGreen = Color(red: 0.0, green: 1.0, blue: 0.0)
    static let xiloOrange = Color(red: 1.0, green: 0.5, blue: 0.0) // Cor da Sombra
}

struct XiloStyle: ViewModifier {
    var color: Color
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(color, style: StrokeStyle(lineWidth: 3, lineCap: .butt, dash: [1]))
            )
            .shadow(color: color.opacity(0.6), radius: 0, x: 4, y: 4)
    }
}

// --- 2. MODELS (DADOS) ---

struct Vector: Equatable {
    var x: Double
    var y: Double
    static func + (lhs: Vector, rhs: Vector) -> Vector { Vector(x: lhs.x + rhs.x, y: lhs.y + rhs.y) }
    static func * (scalar: Double, vec: Vector) -> Vector { Vector(x: scalar * vec.x, y: scalar * vec.y) }
}

struct GridPoint: Hashable, Equatable {
    var i: Int
    var j: Int
}

struct LevelConfig {
    let title: String
    let instruction: String
    let basis1: Vector
    let basis2: Vector
    
    let target: GridPoint       // Alvo da Mari
    
    // NOVOS CAMPOS PARA ENTRELAÇAMENTO
    let isEntangled: Bool       // Ativa o modo Sombra?
    let shadowTarget: GridPoint // Alvo da Sombra (se houver)
    let shadowStart: GridPoint  // Onde a sombra começa
    
    let bgImageName: String
    let themeColor: Color
}

enum GameState {
    case introGlitch
    case mariBriefing
    case tutorial
    case entangled
    case challenge
    case victory
}
