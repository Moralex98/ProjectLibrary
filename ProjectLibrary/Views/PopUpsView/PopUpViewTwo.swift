//
//  PopUpviewTwo.swift
//  ProjectLibrary
//
//  Created by Freddy Morales on 27/10/24.
//

import SwiftUI

struct PopUpViewTwo: View {
    @Binding var popup: Bool
    @Binding var message: String
    @Binding var success: Bool
    
    // Acciones que se ejecutan al presionar "Pagar" o "Regresar"
    var onPay: () -> Void
    var onCancel: () -> Void

    var body: some View {
        ZStack {
            if popup {
                Color.black.opacity(0.2)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    ZStack {
                        Image(systemName: "bubble.right.fill")
                            .resizable()
                            .foregroundColor(success ? .cyan : .red)
                            .frame(width: 650, height: 250)
                        VStack {
                            Text(message)
                                .font(.title.bold())
                                .foregroundColor(success ? .black : .white)
                                .multilineTextAlignment(.center)
                                .padding()
                                .fixedSize(horizontal: false, vertical: true)
                            HStack(spacing: 20) {
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        popup = false
                                    }
                                    onPay() // Llamada a la acción de pago
                                }, label: {
                                    Text("Pagar")
                                        .font(.title3.bold())
                                        .foregroundColor(.black)
                                        .padding(8)
                                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
                                })
                                .padding(.top, 10)
                                
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        popup = false
                                    }
                                    onCancel() // Llamada a la acción de cancelar
                                }, label: {
                                    Text("Regresar")
                                        .font(.title3.bold())
                                        .foregroundColor(.black)
                                        .padding(8)
                                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
                                })
                                .padding(.top, 10)
                            }
                        }
                        .padding(20)
                    }
                    .offset(x: 235)
                    
                    Image("niño")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400)
                        .offset(x: 435, y: -2)
                }
                .transition(.move(edge: .trailing))
                .animation(.easeInOut(duration: 0.5), value: popup)
                .padding(.trailing)
            }
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct PopUpViewTwo_Previews: PreviewProvider {
    @State static var popup = true
    @State static var message = "¡Pago exitoso!"
    @State static var success = true
    
    static var previews: some View {
        PopUpViewTwo(
            popup: $popup,
            message: $message,
            success: $success,
            onPay: {
                print("Pago realizado en el preview.")
            },
            onCancel: {
                print("Se eligió regresar en el preview.")
            }
        )
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
