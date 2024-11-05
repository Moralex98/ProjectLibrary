//
//  AddStudentView.swift
//  MyProjectLibrary
//
//  Created by Freddy Morales on 17/09/24.
//

import SwiftUI

struct AddStudentView: View {
    // Variables para almacenar la entrada del usuario
    @State private var name: String = ""
    @State private var lastName: String = ""
    @State private var grade: String = ""
    @State private var group: String = ""
    @State private var phoneNumber: String = ""
    
    // Estado del popup
    @State private var showPopup = false
    @State private var popupMessage = ""
    @State private var popupSuccess = false
    
    var UISW: CGFloat = UIScreen.main.bounds.width
    var UISH: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationView {
            ZStack {
                // Fondo degradado
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(alignment: .center, spacing: 40) {
                    Text("Agregar Nuevo Estudiante")
                        .font(.custom("Avenir Next", size: 36)) // Fuente estilizada para el título
                        .foregroundColor(.black)
                        .padding(.bottom, 10)
                    
                    // Línea divisora (elige color entre rosa o blanco)
                //    Divider()
                       // .frame(width: 600)
                   //     .background(Color.pink) // Línea divisora en color rosa
                        //.background(Color.white) // Línea divisora en color blanco (descomenta esta línea si prefieres blanco)
                    
                    VStack(spacing: 20) {
                        TextField("Ingresa tu nombre", text: $name)
                            .padding(15) // Ajuste del padding para reducir la altura
                            .frame(width: 600) // Ancho ajustado a 400
                            .background(Color(.systemGray6))
                            .cornerRadius(5)
                            .font(.custom("Avenir Next", size: 30)) // Fuente estilizada para el campo de texto
                            .disableAutocorrection(true)
                            .onChange(of: name) { newValue in
                                self.name = newValue.capitalized
                            }
                        
                        TextField("Ingresa tu apellido", text: $lastName)
                            .padding(15) // Ajuste del padding para reducir la altura
                            .frame(width: 600) // Ancho ajustado a 400
                            .background(Color(.systemGray6))
                            .cornerRadius(5)
                            .font(.custom("Avenir Next", size: 30)) // Fuente estilizada para el campo de texto
                            .disableAutocorrection(true)
                            .onChange(of: lastName) { newValue in
                                self.lastName = newValue.capitalized
                            }
                        
                        TextField("Ingresa tu grado", text: $grade)
                            .keyboardType(.numberPad)
                            .padding(15) // Ajuste del padding para reducir la altura
                            .frame(width: 600) // Ancho ajustado a 400
                            .background(Color(.systemGray6))
                            .cornerRadius(5)
                            .font(.custom("Avenir Next", size: 30)) // Fuente estilizada para el campo de texto
                            .disableAutocorrection(true)
                        
                        TextField("Ingresa tu grupo", text: $group)
                            .padding(15) // Ajuste del padding para reducir la altura
                            .frame(width: 600) // Ancho ajustado a 400
                            .background(Color(.systemGray6))
                            .cornerRadius(5)
                            .font(.custom("Avenir Next", size: 30)) // Fuente estilizada para el campo de texto
                            .disableAutocorrection(true)
                            .onChange(of: group) { newValue in
                                self.group = newValue.uppercased()
                            }
                        
                        TextField("Ingresa tu número de teléfono", text: $phoneNumber)
                            .keyboardType(.numberPad)
                            .padding(15) // Ajuste del padding para reducir la altura
                            .frame(width: 600) // Ancho ajustado a 400
                            .background(Color(.systemGray6))
                            .cornerRadius(5)
                            .font(.custom("Avenir Next", size: 30)) // Fuente estilizada para el campo de texto
                            .disableAutocorrection(true)
                    }
                    
                    Button(action: {
                        // Validar que los campos no estén vacíos y tienen los valores correctos
                        hanledStudentAction(isSelected: true)
                    }, label: {
                        Text("Guardar Estudiante")
                            .padding()
                            .background(Color.purple.opacity(0.8)) // Color púrpura para el botón
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .font(.custom("Avenir Next", size: 25)) // Fuente estilizada para el botón
                    })
                    .padding(.top)
                }
                .padding(20)
                
                NavigationLink(destination: StudentListView()) {
                    Image(systemName: "arrowshape.turn.up.right.fill")
                        .font(.title2.bold())
                        .frame(width: 30, height: 10)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue.opacity(0.8))
                        .cornerRadius(15)
                }
                .position(x: UISW * 0.95, y: UISH * 0.04)
            }
            .overlay(
                Group {
                    if showPopup {
                        PopUpView(popup: $showPopup, message: $popupMessage, success: $popupSuccess)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                            .background(Color.black.opacity(0.3))
                            .transition(.opacity)
                            .animation(.easeInOut, value: showPopup)
                            .ignoresSafeArea()
                    }
                }
            )
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden()
    }
    
    func hanledStudentAction(isSelected: Bool) {
        guard let gradeInt = Int(grade), gradeInt >= 1 && gradeInt <= 6 else {
            popupMessage = "El grado debe estar entre 1 y 6."
            popupSuccess = false
            showPopup = true
            return
        }
        
        let validGroups = ["A", "B", "C"]
        if !validGroups.contains(group.uppercased()) {
            popupMessage = "El grupo debe ser A, B o C."
            popupSuccess = false
            showPopup = true
            return
        }
        
        if name.isEmpty || lastName.isEmpty || grade.isEmpty || group.isEmpty || phoneNumber.isEmpty {
            popupMessage = "Por favor, complete todos los campos."
            popupSuccess = false
            showPopup = true
            return
        }
        
        // Validación para el número de teléfono
        if phoneNumber.count != 10 || Int(phoneNumber) == nil {
            popupMessage = "El número de teléfono debe tener 10 dígitos."
            popupSuccess = false
            showPopup = true
            return
        }
        
        // Llamar a la función para agregar fila en la base de datos SQLite
        DB_StudentManager().addStudent(
            nameValue: self.name,
            lastNameValue: self.lastName,
            gradeValue: Int64(self.grade) ?? 0,
            groupValue: self.group,
            phoneNumberValue: Int64(self.phoneNumber) ?? 0
        )
        
        // Limpiar los campos de texto
        self.name = ""
        self.lastName = ""
        self.grade = ""
        self.group = ""
        self.phoneNumber = ""
        
        // Mostrar popup de éxito
        popupMessage = "Estudiante agregado correctamente."
        popupSuccess = true
        showPopup = true
    }
}

struct AddStudentView_Previews: PreviewProvider {
    static var previews: some View {
        AddStudentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
