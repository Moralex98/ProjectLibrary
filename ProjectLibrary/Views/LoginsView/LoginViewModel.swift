//
//  LoginViewModel.swift
//  MyProjectLibrary
//
//  Created by Freddy Morales on 24/09/24.
//

import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var showMyLibrary: Bool = false
    @Published var showLoginButton: Bool = false
    @Published var loginMessage: String = ""
    
    // Cambiar la función para aceptar un closure que indique el éxito
    func login(completion: @escaping (Bool) -> Void) {
        let trimmedUsername = username.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedUsername == "admin" && trimmedPassword == "admin1" {
            loginMessage = "Inicio de sesión exitoso"
            completion(true)  // Éxito
        } else {
            loginMessage = "Nombre de usuario o contraseña incorrectos"
            completion(false)  // Fallo
        }
    }

    // Función para activar las animaciones
    func activateAnimations() {
        withAnimation {
            showMyLibrary = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation {
                self.showLoginButton = true
            }
        }
    }
}
