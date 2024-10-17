//
//  Instruction2.swift
//  ConociendoSwift
//
//  Created by Sireth Ventura on 25/09/24.
//
import SwiftUI

struct Instruction2: View {
    @Binding var popup: Bool
    @Binding var success: Bool
    @State var message1:String = "1. Botón (+): Agrega un nuevo libro."
    @State var message2:String = "2. Cámara: Escanea el ISBN y agrega el libro automáticamente."
    @State var message3:String = "3. Flecha de regreso: Vuelve a la lista de libros."
    @State var message4:String = "4. Deslizar a la derecha: Elimina el libro."
    @State var message5:String = "5. Deslizar a la izquierda: Edita el libro."
    
    var body: some View {
        ZStack {
            if popup {
                HStack {
                    Spacer()
                    VStack {
                        // Burbuja de mensaje
                        ZStack {
                            Image("POCOYO")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 890) // Ajuste de tamaño más razonable
                                .offset(x: 35, y: 25) // Posiciona al niño debajo de la burbuja
                            
                            VStack {
                                ZStack {
                                    VStack(spacing: 8){
                                        Text(message1)
                                        Text(message2)
                                        Text(message3)
                                        Text(message4)
                                        Text(message5)
                                    }
                                    .font(.title2.bold())
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .lineLimit(nil) // Permite que el texto se ajuste a varias líneas
                                    .frame(width: 650) // Limita el ancho del texto dentro del rectángulo
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
                                        .font(.title.bold())
                                        .foregroundColor(.black)
                                        .padding(8)
                                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.cyan, lineWidth: 2))
                                        .offset(x:10,y: 5)
                                })
                                .padding(.top, 10)
                                
                            }
                            .padding(20) // Añade padding para evitar que el texto toque los bordes de la burbuja
                            .offset(x: -110, y: -150)
                        }
                    }
                    .transition(.move(edge: .trailing)) // Transición desde el lado derecho para todo el bloque
                    .animation(.easeInOut(duration: 0.5), value: popup) // Animación para el popup y el niño
                    .padding(.trailing)
                }
            }
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct Instruction2_Previews: PreviewProvider {
    @State static var popup = true
    @State static var succes = true
    
    static var previews: some View {
        Instruction2(popup: $popup, success: $succes)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
