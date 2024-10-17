import SwiftUI

struct Instruction1: View {
    @Binding var popup: Bool
    @Binding var success: Bool
    @State var message1: String = "1. Botón (+): Agrega un nuevo alumno."
    @State var message2: String = "2. Regresar: (flecha hacia atrás) Vuelve a la lista de alumnos."
    @State var message3: String = "3. Deslizar derecha: Elimina alumno."
    @State var message4: String = "4. Deslizar izquierda: Edita alumno."

    var body: some View {
        ZStack {
            if popup {
                HStack {
                    Spacer()
                    VStack {
                        // Burbuja de mensaje
                        ZStack {
                            Image("PINOCHO")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 2300, height: 950)
                                .offset(x: -2, y: -2) // Posiciona al niño debajo de la burbuja
                            
                            VStack {
                                ZStack{
                                    VStack(spacing: 8) {
                                        Text(message1)
                                        Text(message2)
                                        Text(message3)
                                        Text(message4)
                                    }
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .lineLimit(nil) // Permite que el texto se ajuste a varias líneas
                                    .frame(width: 400) // Limita el ancho del texto dentro del rectángulo
                                    .fixedSize(horizontal: false, vertical: true) // Evita que el texto crezca más allá del frame
                                    .minimumScaleFactor(0.5) // Reduce el tamaño del texto si es necesario para que se ajuste
                                }
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        popup = false
                                        success = true
                                    }
                                }, label: {
                                    Text("Cerrar")
                                        .font(.title3.bold())
                                        .foregroundColor(.black)
                                        .padding(8)
                                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
                                        .offset(x: -50, y: -15)
                                })
                                .padding(.top, 10)
                            }
                            .padding(20)
                            .offset(x: 150, y: -80)
                        }
                    }
                    .transition(.move(edge: .trailing))
                    .animation(.easeInOut(duration: 0.5), value: popup)
                    .padding(.trailing)
                }
            }
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct Instruction1_Previews: PreviewProvider {
    @State static var popup = true
    @State static var succes = true
    
    static var previews: some View {
        Instruction1(popup: $popup, success: $succes)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

