//
//  ContentView.swift
//  ProjectLibrary
//
//  Created by Freddy Morales on 03/10/24.
//
import SwiftUI

struct ContentView: View {
    @State private var isMenuOpen = false
    @State private var selectedView: AnyView? = nil
    @State private var isLoggedIn = false  // Controla la navegación a ContentView
    @State private var isLoading = false  // Controla la navegación a LoadingView

    var body: some View {
        ZStack {
            // Mostrar el ParallaxView si no hay ninguna vista seleccionada
            if selectedView == nil {
                ParallaxView()
                    .ignoresSafeArea()
            } else if isLoading {
                // Mostrar LoadingView cuando esté cargando
                LoadingView(isLoading: $isLoading, isLoggedIn: $isLoggedIn)
                    .transition(.opacity)
            }

            // Mostrar la vista seleccionada si existe
            if let selectedView = selectedView {
                selectedView
                    .transition(.move(edge: .trailing)) // Añade una transición suave
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea() // Asegura que cubra toda la pantalla
            }

            // Side menu con botón dentro de la pestaña
            HStack(spacing: 0) {
                VStack {
                    // Botón para abrir/cerrar el menú
                    Button(action: {
                        withAnimation {
                            self.isMenuOpen.toggle()
                        }
                    }) {
                        Image(systemName: isMenuOpen ? "chevron.left.circle.fill" : "list.bullet")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding()
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .background(
                    isMenuOpen ?
                        AnyView(LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.5039, green: 0.4275, blue: 0.8421),
                                Color(red: 0.0, green: 0.5, blue: 0.5)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                    : AnyView(Color.clear.opacity(0.1))
                )
                .edgesIgnoringSafeArea(.all)
                .transition(.move(edge: .leading))

                // Menú lateral
                if isMenuOpen {
                    VStack(alignment: .leading, spacing: 30) {
                        
                        Button(action: {
                            // Regresa al ParallaxView cuando se presiona el icono person.circle
                            withAnimation {
                                selectedView = nil
                                self.isMenuOpen.toggle()
                            }
                        }) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.white)
                                .padding(.bottom, 50)
                        }
                        
                        Button(action: {
                            selectedView = AnyView(StudentListView())
                            withAnimation {
                                self.isMenuOpen.toggle()
                            }
                        }) {
                            HStack {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.white)
                                Text("Alumno")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                            }
                        }

                        Button(action: {
                            selectedView = AnyView(BookListView())
                            withAnimation {
                                self.isMenuOpen.toggle()
                            }
                        }) {
                            HStack {
                                Image(systemName: "book.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.white)
                                Text("Libros")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                            }
                        }

                        Button(action: {
                            selectedView = AnyView(AddLoanView())
                            withAnimation {
                                self.isMenuOpen.toggle()
                            }
                        }) {
                            HStack {
                                Image(systemName: "character.book.closed.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.white)
                                Text("Prestamos")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Button(action: {
                            // Lógica para el botón de Reportes
                            selectedView = AnyView(ReportsView())
                            withAnimation {
                                self.isMenuOpen.toggle()
                            }
                        }) {
                            HStack {
                                Image(systemName: "creditcard.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.white)
                                Text("Reportes")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                            }
                        }
                        
//                        Button(action: {
//                            // Lógica para el botón de Reportes
//                            selectedView = AnyView(LoginView())
//                            withAnimation {
//                                self.isMenuOpen.toggle()
//                            }
//                        }) {
//                            HStack {
//                                Image(systemName: "rectangle.portrait.and.arrow.right.fill")
//                                    .resizable()
//                                    .frame(width: 30, height: 30)
//                                    .foregroundColor(.white)
//                                Text("Log out")
//                                    .font(.largeTitle)
//                                    .foregroundColor(.white)
//                            }
//                        }
                        Spacer()
                    }
                    .padding(.top, 50)
                    .padding()
                    .frame(width: 250)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.5039, green: 0.4275, blue: 0.8421),
                                Color(red: 0.0, green: 0.5, blue: 0.5)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .edgesIgnoringSafeArea(.all)
                }

                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
