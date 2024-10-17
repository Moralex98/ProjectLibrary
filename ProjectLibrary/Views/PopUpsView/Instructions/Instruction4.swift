//
//  Instruction4.swift
//  ConociendoSwift
//
//  Created by Sireth Ventura on 25/09/24.
//

import SwiftUI

struct Instruction4: View {
    @Binding var popup: Bool
    @Binding var success: Bool
    
    @State var message1:String = "1.El botón 'Libros en Préstamo' muestra los libros prestados"
    @State var message2:String = "2.El botón 'Libros con Multas' muestra alumnos."
    @State var message3:String = "3.Retrasos mayores a 7 días y una multa de 5 pesos por día."
    

    

    var body: some View {
        ZStack {
            if popup {
                HStack {
                    Spacer()
                    VStack {
                        // Burbuja de mensaje
                        ZStack {
                            Image("CONEJO")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 1800, height: 900)
                                .offset(x: -2, y: -2) // Posiciona al niño debajo de la burbuja
                            
                            VStack {
                                ZStack {
                                    VStack(spacing: 8) {
                                        Text(message1)
                                        Text(message2)
                                        Text(message3)
                                        
                                    }
                                    .font(.title2.bold())
                                    .foregroundColor(.black)
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
                                        .font(.title2.bold())
                                        .foregroundColor(.white)
                                        .padding(8)
                                        .background(Color.green)
                                })
                                .cornerRadius(10)
                                .padding(.top, 10)
                            }
                            .padding(20)
                            .offset(x: 9, y: 220)
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


struct Intruction4_Previews: PreviewProvider {
    @State static var popup = true
    @State static var success = true
    
    static var previews: some View {
        Instruction4(popup: $popup, success: $success)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

