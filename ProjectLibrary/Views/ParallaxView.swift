//
//  ParallaxView.swift
//  MyProjectLibrary
//
//  Created by Freddy Morales on 17/09/24.
//

import SwiftUI

struct ParallaxView: View {
    @State var popUp: Bool = false
    @State var succes: Bool = false
    @State var popUp2: Bool = false
    @State var succes2: Bool = false
    @State var popUp3: Bool = false
    @State var succes3: Bool = false
    @State var popUp4: Bool = false
    @State var succes4: Bool = false
    
    @State private var hOffset: CGFloat = .zero
    @State private var vOffset: CGFloat = .zero
    @State private var cloudLevitating: Bool = false // Controla la levitación de la nube
    
    var body: some View {
        ZStack {
            // Fondo con gradiente de amanecer
            LinearGradient(gradient: Gradient(
                colors: [
                    Color(red: 0.05, green: 0.07, blue: 0.23), // Noche oscura
                    Color(red: 0.36, green: 0.22, blue: 0.50), // Violeta tenue
                    Color(red: 0.64, green: 0.42, blue: 0.60), // Amanecer frío
                    Color(red: 0.94, green: 0.76, blue: 0.40), // Primeros rayos
                    Color(red: 1.0, green: 0.89, blue: 0.76),  // Sol en el horizonte
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            // ScrollView para el desplazamiento parallax
            ScrollView([.vertical, .horizontal], showsIndicators: false) {
                ZStack {
                    GeometryReader { geometry in
                        let geoSize = geometry.size
                        
                        // Tamaños ajustados para iPad 10
                        let lunaSize: CGFloat = 700 // Tamaño de la luna
                        let nubeWidth: CGFloat = 360 // Tamaño de las nubes
                        let nubeHeight: CGFloat = 191
                        
                        // Luna de 700x700 píxeles, colocada detrás de la montaña y centrada
                        Image("luna")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: lunaSize, height: lunaSize) // Tamaño de la luna
                            .offset(x: 1200, y: 0) // Posición fija de la luna detrás de la montaña
                            .modifier(ParallaxModifier(hOffset: $hOffset, vOffset: $vOffset, magnitude: 0.3))
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    if !succes3 {
                                        popUp3 = true
                                    } else {
                                        succes3 = false
                                    }
                                }
                            }
                        
                        // Nube izquierda luna
                        Image("nubes")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 400, height: 300) // Tamaño de las nubes
                            .offset(x: 1200, y: cloudLevitating ? 200 : 220) // Movimiento de levitación
                            .opacity(0.8) // Ajusta la opacidad de la nube
                            .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: cloudLevitating)
                            //.contentShape(Rectangle()) // Asegura que toda la imagen sea interactiva
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    if !succes2 {
                                        popUp2 = true
                                    } else {
                                        succes2 = false
                                    }
                                }
                            }
                        
                        // nube lado derecho luna
                        Image("nubes")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 300, height: 200) // Tamaño de las nubes
                            .offset(x: 1600, y: cloudLevitating ? 140 : 220) // Movimiento de levitación
                            .opacity(0.4) // Ajusta la opacidad de la nube
                            .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true), value: cloudLevitating)
                            //.contentShape(Rectangle()) // Asegura que toda la imagen sea interactiva
                            
                        
                        //nube derecha- izquierda por debajo de la luna
                        Image("nubes")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 200, height: 250) // Tamaño de las nubes
                            .offset(x: cloudLevitating ? 1000 : 1700, y: 390) // Movimiento de levitación
                            .opacity(0.5) // Ajusta la opacidad de la nube
                            .animation(Animation.easeInOut(duration: 8).repeatForever(autoreverses: true), value: cloudLevitating)
                            
                        
                        //primer nube a la izquierda
                        Image("nubes")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 400, height: 300) // Tamaño de las nubes
                            .offset(x: 100, y: cloudLevitating ? 190 : 230) // Movimiento de levitación
                            .opacity(0.3) // Ajusta la opacidad de la nube
                            .animation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true), value: cloudLevitating)
                            .contentShape(Rectangle()) // Asegura que toda la imagen sea interactiva
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    if !succes {
                                        popUp = true
                                    } else {
                                        succes = false
                                    }
                                }
                            }
                        // Montaña grande, ajustada al tamaño de desplazamiento
                        Image("montaña1")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 1600, height: 800) // Tamaño de la montaña
                            .offset(x: cloudLevitating ? -300 : -250, y: 700) // Ajustada sin dejar espacio en la parte inferior
                            .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true), value: cloudLevitating)
                        
                        Image("montaña1")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 1600, height: 800) // Tamaño de la montaña
                            .offset(x: cloudLevitating ? 1500 : 1550, y: 450) // Ajustada sin dejar espacio en la parte inferior
                            .animation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true), value: cloudLevitating)
                        
                        Image("montaña2")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 1600, height: 800) // Tamaño de la montaña
                            .offset(x: cloudLevitating ? 600 : 620, y: 670) // Ajustada sin dejar espacio en la parte inferior
                            .animation(Animation.easeInOut(duration: 4).repeatForever(autoreverses: true), value: cloudLevitating)
                        
                        
                        Image("montaña2")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 1600, height: 800) // Tamaño de la montaña
                            .offset(x: 1950, y: 670) // Ajustada sin dejar espacio en la parte inferior
                            .modifier(ParallaxModifier(hOffset: $hOffset, vOffset: $vOffset, magnitude: 1.0))
                        
                        //nube arriba de la montaña
                        Image("nubes")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 400, height: 200) // Tamaño de las nubes
                            .offset(x:2000, y: cloudLevitating ? 500 : 560) // Movimiento de la nube
                            .opacity(0.5) // Ajusta la opacidad de la nube
                            .animation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true), value: cloudLevitating)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    if !succes4 {
                                        popUp4 = true
                                    } else {
                                        succes4 = false
                                    }
                                }
                            }
                        
                    }
                }
                // Asegura que el contenido sea grande para permitir el desplazamiento en todas las direcciones
                .frame(width: UIScreen.main.bounds.width * 2.5, height: UIScreen.main.bounds.height * 2)
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        withAnimation(nil) { // Desactivar la animación del parallax
                            hOffset = value.translation.width
                            vOffset = value.translation.height
                        }
                    }
            )
            if (popUp == true) {
                Color.black
                    .opacity(0.5)
                Instruction1(popup: $popUp, success: $succes)
            }
            if (popUp2 == true) {
                Color.black
                    .opacity(0.5)
                Instruction2(popup: $popUp2, success: $succes2)
            }
            if (popUp3 == true) {
                Color.black
                    .opacity(0.5)
                Instruction3(popup: $popUp3, success: $succes3)
            }
            if (popUp4 == true) {
                Color.black
                    .opacity(0.5)
                Instruction4(popup: $popUp4, success: $succes4)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            // Iniciar el efecto de levitación cuando la vista aparezca
            startCloudLevitating()
        }
    }
    
    // Función para iniciar la levitación de las nubes
    func startCloudLevitating() {
        cloudLevitating = true
    }
}

// Modificador para el efecto parallax
struct ParallaxModifier: ViewModifier {
    @Binding var hOffset: CGFloat
    @Binding var vOffset: CGFloat
    var magnitude: CGFloat

    func body(content: Content) -> some View {
        content
            .offset(x: hOffset * magnitude, y: vOffset * magnitude)
    }
}

struct ParallaxView_Previews: PreviewProvider {
    static var previews: some View {
        ParallaxView()
            .previewDevice("iPad (10th generation)") // Configurado para el iPad 10
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
