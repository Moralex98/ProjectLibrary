//
//  PopUpView.swift
//  MyProjectLibrary
//
//  Created by Freddy Morales on 17/09/24.
//

import SwiftUI

struct PopUpView: View {
    @Binding var popup: Bool
    @Binding var message: String
    @Binding var success: Bool

    var body: some View {
        ZStack {
            if popup {
                // Fondo oscuro detrás del popup
                Color.black.opacity(0.2)
                    .edgesIgnoringSafeArea(.all)

                HStack {
                    Spacer()
                    VStack {
                        // Burbuja de mensaje
                        ZStack {
                            Image(systemName: "bubble.right.fill")
                                .resizable()
                                .foregroundColor(success ? .cyan : .red)
                                .frame(width: 650, height: 250) // Ajuste del tamaño de la burbuja
                            VStack {
                                Text(message)
                                    .font(.title3.bold())
                                    .foregroundColor(success ? .black: .white)
                                    .multilineTextAlignment(.center) // Texto centrado en varias líneas
                                    .padding()
                                    .fixedSize(horizontal: false, vertical: true) // Evita que el texto se salga horizontalmente

                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        popup = false
                                    }
                                }, label: {
                                    Text("Cerrar")
                                        .font(.title3.bold())
                                        .foregroundColor(.black)
                                        .padding(8)
                                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
                                })
                                .padding(.top, 10)
                            }
                            .padding(20) // Añade padding para evitar que el texto toque los bordes de la burbuja
                        }
                        // Imagen del niño debajo del mensaje, también se moverá junto con el popup
                        Image("niño")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 400)
                            .offset(x: 135, y: -2) // Posiciona al niño debajo de la burbuja
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

struct RegisterView_Previews: PreviewProvider {
    @State static var popup = true
    @State static var message = "Préstamo exitoso"
    @State static var success = true
    
    static var previews: some View {
        PopUpView(popup: $popup, message: $message, success: $success)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

