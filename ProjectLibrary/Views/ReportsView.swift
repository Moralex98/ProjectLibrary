//
//  ReportsView.swift
//  MyProjectLibrary
//
//  Created by Freddy Morales on 17/09/24.
//

import SwiftUI

struct ReportsView: View {
    var body: some View {
        NavigationView { // Envolvemos todo en un NavigationView para habilitar la navegación
            ZStack {
                // Fondo degradado
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.1)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                GeometryReader { geometry in
                    VStack {
                        HStack(spacing: 30) {
                            // Botón "Libros en préstamo"
                            NavigationLink(destination: LoanListView()) { // Navegar a LoanListView
                                VStack {
                                    Image(systemName: "book.fill")
                                        .font(.system(size: geometry.size.width * 0.07)) // Ajusta el tamaño del icono proporcionalmente al ancho de la pantalla
                                        .foregroundColor(.gray)
                                    Text("Libros en préstamo")
                                        .font(.system(size: geometry.size.width * 0.04, weight: .bold)) // Ajusta el tamaño del texto proporcionalmente
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .frame(width: geometry.size.width * 0.3, height: geometry.size.width * 0.3) // Botones ajustados proporcionalmente
                                .background(Color.purple.opacity(0.1))
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.purple.opacity(0.5), lineWidth: 5))
                            }
                            
                            // Botón "Libros con multas"
                            NavigationLink(destination: FinesListView()) {
                                VStack {
                                    Image(systemName: "creditcard.fill")
                                        .font(.system(size: geometry.size.width * 0.07)) // Ajusta el tamaño del icono proporcionalmente al ancho de la pantalla
                                        .foregroundColor(.gray)
                                    Text("Libros con multas")
                                        .font(.system(size: geometry.size.width * 0.04, weight: .bold)) // Ajusta el tamaño del texto proporcionalmente
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .frame(width: geometry.size.width * 0.3, height: geometry.size.width * 0.3) // Botones ajustados proporcionalmente
                                .background(Color.purple
                                    .opacity(0.1))
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.purple.opacity(0.5), lineWidth: 5))
                            }
                        }
                        .frame(maxWidth: .infinity) // Asegura que el HStack se expanda a todo el ancho
                        .padding(.top, 50) // Añade un padding superior para separar del borde superior
                    }
                    .frame(maxHeight: .infinity) // Centra verticalmente
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .preferredColorScheme(.light) // Fuerza el modo claro en esta vista
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden()
    }
}

struct ReportsView_Previews: PreviewProvider {
    static var previews: some View {
        ReportsView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
