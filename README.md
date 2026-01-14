# Quantum Cordel 🌵⚛️

**Quantum Cordel** é uma experiência narrativa e educativa desenvolvida em **SwiftUI**. O projeto une a estética tradicional da **literatura de cordel** e da **xilogravura** com conceitos fundamentais da **Computação Quântica**, como Superposição e Emaranhamento.

## 🍎 Apple Swift Student Challenge
Este projeto foi desenvolvido como parte do **Swift Student Challenge 2026**. Ele demonstra o uso de tecnologias Apple para criar uma experiência educacional acessível, transformando conceitos científicos complexos em uma jornada cultural e visualmente rica.

## 📖 Proposta Narrativa
O jogo é guiado pela personagem **Mariana**, que apresenta o mundo quântico através de rimas e desafios visuais. O objetivo é desmistificar a ideia de que a física de partículas é algo inacessível, trazendo-a para o contexto cultural do sertão brasileiro.

## 🎮 Mecânicas Principais

### 1. Superposição Quântica (A Moeda)
* Explora o conceito de coexistência de estados.
* O jogador aprende que, no nível atômico, as coisas não são apenas "zero ou um", mas uma combinação de vetores.

### 2. Emaranhamento (Entangled Grid)
* **Conexão Instantânea**: O jogador controla Mariana (Azul) e sua Sombra (Rosa) simultaneamente.
* **Movimento Invertido**: Quando a Mariana se move em um eixo, a Sombra reage na direção oposta, simulando a correlação quântica.
* **Lógica de Grid**: O desafio ocorre em uma grade 5x5 com limites matemáticos que garantem a precisão dos estados quânticos.

## 🛠️ Detalhes Técnicos

* **Framework**: SwiftUI (100%).
* **Arquitetura**: MVVM (Model-View-ViewModel).
* **Animações**: Uso de `withAnimation` e transições `easeInOut` para simular a fluidez quântica.
* **Áudio**: Feedback sonoro imersivo para ações de sucesso, movimento e erro.

## 🎨 Design e Assets
O projeto utiliza uma paleta de cores vibrante (**Ciano** e **Magenta**) que contrasta com o fundo escuro de xilogravura, criando uma atmosfera "Cyber-Sertão".

* **Tipografia**: Uso de fontes monoespaçadas para o cabeçalho e serifadas para a narrativa de cordel.

## 🚀 Como Rodar o Projeto

1. Clone o repositório.
2. Certifique-se de que os assets de imagem estão na pasta `Assets.xcassets`.
3. Abra o projeto no **Xcode** ou **Swift Playgrounds**.
4. Execute no simulador de iPad ou iPhone.

---

### Exemplo de Lógica: O Movimento Emaranhado
```swift
// Lógica de espelhamento presente no EntagledViewModels.swift
func move(di: Int, dj: Int) {
    if config.isEntangled {
        nextShadowI -= di // A inversão quântica dos eixos
        nextShadowJ -= dj
    }
}
