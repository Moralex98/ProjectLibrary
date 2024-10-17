//
//  LoginView.swift
//  MyProjectLibrary
//
//  Created by Freddy Morales on 17/09/24.
//
import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()  // Instancia del ViewModel
    @State private var isLoggedIn = false  // Controla la navegación a ContentView
    @State private var isLoading = false  // Controla la navegación a LoadingView
    @State private var showPassword = false  // Mostrar u ocultar la contraseña
    
    var body: some View {
        ZStack {
            if isLoggedIn {
                // Si ya está logueado, muestra ContentView
                ContentView()
                    .transition(.move(edge: .trailing))
            } else if isLoading {
                // Mostrar LoadingView cuando esté cargando
                LoadingView(isLoading: $isLoading, isLoggedIn: $isLoggedIn)
                    .transition(.opacity)
            } else {
                // Vista de login
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green.opacity(0.2)]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    // Animación de MY LIBRARY
                    HStack {
                        ForEach(["M", "Y2"], id: \.self) { letter in
                            Image(letter)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 130, height: 130)
                                .scaleEffect(viewModel.showMyLibrary ? 1 : 0)
                                .rotationEffect(.degrees(viewModel.showMyLibrary ? 0 : 360))
                                .opacity(viewModel.showMyLibrary ? 1 : 0)
                                .animation(Animation.spring(response: 0.6, dampingFraction: 0.5, blendDuration: 0.3).delay(Double(letter.first!.asciiValue! - 64) * 0.1), value: viewModel.showMyLibrary)
                        }
                    }
                    
                    // LIBRARY Animation
                    HStack {
                        ForEach(["L", "I", "B", "R", "A", "R2", "Y2"], id: \.self) { letter in
                            Image(letter)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 130, height: 130)
                                .scaleEffect(viewModel.showMyLibrary ? 1 : 0)
                                .rotationEffect(.degrees(viewModel.showMyLibrary ? 0 : 360))
                                .opacity(viewModel.showMyLibrary ? 1 : 0)
                                .animation(Animation.spring(response: 0.6, dampingFraction: 0.5, blendDuration: 0.3).delay(Double(letter.first!.asciiValue! - 64) * 0.1), value: viewModel.showMyLibrary)
                        }
                    }
                    
                    Spacer().frame(height: 20)
                    
                    // Campo para ingresar el nombre de usuario
                    TextField("Usuario", text: $viewModel.username)
                        .padding()
                        .background(Color.white.opacity(0.3))
                        .cornerRadius(10)
                        .multilineTextAlignment(.center)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .frame(width: 300)
                        .padding(.horizontal)
                    
                    // Campo para ingresar la contraseña con el botón de visibilidad
                    HStack {
                        if showPassword {
                            TextField("Contraseña", text: $viewModel.password)
                                .padding()
                                .background(Color.white.opacity(0.3))
                                .cornerRadius(10)
                                .multilineTextAlignment(.center)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .frame(width: 250)
                        } else {
                            SecureField("Contraseña", text: $viewModel.password)
                                .padding()
                                .background(Color.white.opacity(0.3))
                                .cornerRadius(10)
                                .multilineTextAlignment(.center)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .frame(width: 250)
                        }
                        // Botón para mostrar u ocultar la contraseña
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer().frame(height: 20)
                    
                    // Mensaje de error o éxito
                    if !viewModel.loginMessage.isEmpty {
                        Text(viewModel.loginMessage)
                            .foregroundColor(viewModel.loginMessage == "Inicio de sesión exitoso" ? .green : .red)
                            .font(.subheadline)
                    }
                    
                    // Botón de "Log In" con animación
                    if viewModel.showLoginButton {
                        Button(action: {
                            // Llamar a la función login del ViewModel
                            viewModel.login { success in
                                if success {
                                    // Si el login es exitoso, mostrar la vista de carga y luego redirigir
                                    withAnimation {
                                        isLoading = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                        withAnimation {
                                            isLoggedIn = true
                                            isLoading = false  // Detener la vista de carga
                                        }
                                    }
                                }
                            }
                        }) {
                            Text("Log In")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 10)
                        }
                        .transition(.scale)
                        .animation(.easeIn(duration: 1), value: viewModel.showLoginButton)
                    }
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.activateAnimations()
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
