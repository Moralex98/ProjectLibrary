//
//  Intruction3.swift
//  ConociendoSwift
//
//  Created by Sireth Ventura on 25/09/24.
//

import SwiftUI

struct Instruction3: View {
    @Binding var popup: Bool
    @Binding var success: Bool
    @State var message1: String = "1. El botón 'Conceder Préstamo' permite a un alumno solicitar un libro por una semana. Si el alumno ya tiene un préstamo activo, se mostrará un mensaje de error."
    @State var message2: String = "2. El botón 'Devolver Libro' registra la devolución del libro"
    
    var body: some View {
        ZStack {
            if popup {
                HStack {
                    Spacer()
                    VStack {
                        // Burbuja de mensaje
                        ZStack {
                            Image("BANANA")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 2020, height: 820)
                                .offset(x: -162, y: 30) // Posiciona al niño debajo de la burbuja
                            
                            VStack {
                                ZStack {
                                    VStack(spacing: 8) {
                                        Text(message1)
                                        Text(message2)
                                        
                                    }
                                    .font(.title2.bold())
                                    .foregroundColor(.yellow)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .lineLimit(nil) // Permite que el texto se ajuste a varias líneas
                                    .frame(width: 400) // Limita el ancho del texto dentro del rectángulo
                                    .fixedSize(horizontal: false, vertical: true) // Evita que el texto crezca más allá del frame
                                    .minimumScaleFactor(0.5) // Reduce el tamaño del texto si es necesario para que se ajuste
                                }
                                //.padding()
                                
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
                                        .background(Color.yellow)
                                        .cornerRadius(10)
                                        .offset(x:0, y: 10)
                                })
                                .padding(.top, 10)
                            }
                            .padding(20)
                            .offset(x: 70, y: -200)
                        }
                    }
                    .transition(.move(edge: .trailing))
                    .animation(.easeInOut(duration: 0.5), value: popup)
                    .padding(.trailing)
                }
            }
        }
        //.ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct Intruction3_Previews: PreviewProvider {
    @State static var popup = true
    @State static var succes = true
    
    static var previews: some View {
        Instruction3(popup: $popup, success: $succes)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
