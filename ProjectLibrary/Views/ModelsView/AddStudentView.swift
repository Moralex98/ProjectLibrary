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
                // Fondo de la vista principal
                Color.white
                    .edgesIgnoringSafeArea(.all) // Hace que el fondo cubra toda la pantalla
                
                VStack(alignment: .center, spacing: 60) {
                    Text("Agregar Nuevo Estudiante")
                        .font(.largeTitle)
                        .padding(.bottom, 20)
                    
                    VStack(spacing: 20) {
                        TextField("Ingresa tu nombre", text: $name)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(5)
                            .disableAutocorrection(true)
                            .onChange(of: name) { newValue in
                                self.name = newValue.capitalized
                            }
                        
                        TextField("Ingresa tu apellido", text: $lastName)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(5)
                            .disableAutocorrection(true)
                            .onChange(of: lastName) { newValue in
                                self.lastName = newValue.capitalized
                            }
                        
                        TextField("Ingresa tu grado", text: $grade)
                            .keyboardType(.numberPad)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(5)
                            .disableAutocorrection(true)
                        
                        TextField("Ingresa tu grupo", text: $group)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(5)
                            .disableAutocorrection(true)
                            .onChange(of: group) { newValue in
                                self.group = newValue.uppercased()
                            }
                        
                        TextField("Ingresa tu número de teléfono", text: $phoneNumber)
                            .keyboardType(.numberPad)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(5)
                            .disableAutocorrection(true)
                    }
                    
                    Button(action: {
                        // Validar que los campos no estén vacíos
                        hanledStudentAction(isSelected: true)
                    }, label: {
                        Text("Guardar Estudiante")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    })
                    .padding(.top)
                    .font(.title)
                }
                .padding(20)
                
                NavigationLink(destination: StudentListView()) {
                    Image(systemName: "arrowshape.turn.up.right.fill")
                        .font(.title2.bold())
                        .frame(width: 30, height: 10)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(15)
                }
                .position(x: UISW * 0.95, y: UISH * 0.04)
            }
            .overlay(
                Group {
                    if showPopup {
                        PopUpView(popup: $showPopup, message: $popupMessage, success: $popupSuccess)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                            .background(Color.black.opacity(0.3)) // Fondo oscuro para el popup
                            .transition(.opacity) // Cambiar la animación para evitar movimiento
                            .animation(.easeInOut, value: showPopup)
                            .ignoresSafeArea()
                    }
                }
            )
            .ignoresSafeArea(.keyboard, edges: .bottom) // Evita que el teclado empuje la vista hacia arriba
            .preferredColorScheme(.light) // Fuerza el modo claro en esta vista
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden()
    }
    
    // Función para añadir estudiantes en el botón
    func hanledStudentAction(isSelected: Bool) {
        if name.isEmpty || lastName.isEmpty || grade.isEmpty || group.isEmpty || phoneNumber.isEmpty {
            // Mostrar popup si algún campo está vacío
            popupMessage = "Por favor, complete todos los campos."
            popupSuccess = false
            showPopup = true
        } else {
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
}

struct AddStudentView_Previews: PreviewProvider {
    static var previews: some View {
        AddStudentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
