//
//  EditStudentView.swift
//  MyProjectLibrary
//
//  Created by Freddy Morales on 17/09/24.
//

import SwiftUI

struct EditStudentView: View {
    
    // ID recibido desde la vista anterior
    @Binding var idStudent: Int64
    
    // Variables para almacenar los valores de los campos de entrada
    @State var name: String = ""
    @State var lastName: String = ""
    @State var grade: String = ""
    @State var group: String = ""
    @State var phoneNumber: String = ""
    
    // Para regresar a la vista anterior
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            // Fondo en degradado
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)]),
                startPoint: .top,
                endPoint: .bottom
                    
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Editar Estudiante")
                    .font(.custom("Avenir-Heavy", size: 36))
                    .padding(.bottom, 10)
                
                // Campo de nombre
                TextField("Ingresa tu nombre", text: $name)
                    .padding(15)
                    .frame(width: 550)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .font(.title) // Aumenta el tamaño de la letra
                    .disableAutocorrection(true)
                    .onChange(of: name) { newValue in
                        self.name = newValue.capitalized
                    }
                
                // Campo de apellido
                TextField("Ingresa tu apellido", text: $lastName)
                    .padding(15)
                    .frame(width: 550)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .font(.title) // Aumenta el tamaño de la letra
                    .disableAutocorrection(true)
                    .onChange(of: lastName) { newValue in
                        self.lastName = newValue.capitalized
                    }
                
                // Campo de grado
                TextField("Ingresa tu grado", text: $grade)
                    .keyboardType(.numberPad)
                    .padding(15)
                    .frame(width: 550)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .font(.title) // Aumenta el tamaño de la letra
                    .disableAutocorrection(true)
                
                // Campo de grupo
                TextField("Ingresa tu grupo", text: $group)
                    .padding(15)
                    .frame(width: 550)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .font(.title) // Aumenta el tamaño de la letra
                    .disableAutocorrection(true)
                    .onChange(of: group) { newValue in
                        self.group = newValue.uppercased()
                    }
                
                // Campo de número de teléfono
                TextField("Ingresa tu número de teléfono", text: $phoneNumber)
                    .keyboardType(.numberPad)
                    .padding(15)
                    .frame(width: 550)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .font(.title) // Aumenta el tamaño de la letra
                    .disableAutocorrection(true)
                
                // Botón para actualizar estudiante
                Button(action: {
                    // Llamar a la función para actualizar la fila en la base de datos
                    DB_StudentManager().updateStudent(
                        idValue: self.idStudent,
                        nameValue: self.name,
                        lastNameValue: self.lastName,
                        gradeValue: Int64(self.grade) ?? 0,
                        groupValue: self.group,
                        phoneNumberValue: Int64(self.phoneNumber) ?? 0
                    )
                    // Volver a la vista anterior
                    self.mode.wrappedValue.dismiss()
                    
                }, label: {
                    Text("Editar estudiante")
                        .padding()
                        .frame(width: 250)
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.title2)
                })
                .padding(.top, 20)
            }
            .padding()
            .onAppear {
                // Obtener los datos del estudiante cuando la vista cargue
                if let studentModel = DB_StudentManager().getStudent(idValue: self.idStudent) {
                    // Poblar los campos de texto con los datos del estudiante
                    self.name = studentModel.name
                    self.lastName = studentModel.lastName
                    self.grade = String(studentModel.grade) // Convertir de Int64 a String
                    self.group = studentModel.group
                    self.phoneNumber = String(studentModel.phoneNumber) // Convertir de Int64 a String
                } else {
                    print("No se encontró el estudiante con ID \(self.idStudent)")
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .preferredColorScheme(.light)
    }
}

struct EditStudentView_Previews: PreviewProvider {
    // cuando se usa @Binding en PreviewProvider
    @State static var idStudent: Int64 = 0
    
    static var previews: some View {
        EditStudentView(idStudent: $idStudent)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
