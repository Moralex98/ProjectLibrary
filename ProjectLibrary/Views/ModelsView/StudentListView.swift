//
//  StudentListView.swift
//  MyProjectLibrary
//
//  Created by Freddy Morales on 17/09/24.
//

import SwiftUI

struct StudentListView: View {
    @State private var studentModels: [StudentModel] = []
    @State private var isEditing: Bool = false
    @State private var selectedStudentId: Int64 = 0
    @State private var searchText: String = "" // Variable para el texto de búsqueda
    
    var grupos: [String] = ["A", "B", "C"]
    var grados: [Int] = Array(1...6) // Grados del 1 al 6
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea() // Hace que el fondo cubra toda la pantalla
                
                NavigationLink(destination: EditStudentView(idStudent: self.$selectedStudentId), isActive: self.$isEditing) {
                    EmptyView()
                }
                
                VStack(alignment: .center) {
                    // Agregamos el buscador en la parte superior
                    TextField("Buscar estudiante por nombre...", text: $searchText)
                        .padding(10)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .onChange(of: searchText) { _ in
                            // Actualiza la lista conforme se escribe en el buscador
                            self.studentModels = DB_StudentManager().getStudents()
                        }
                    
                    VStack(spacing: 10) {
                        List {
                            ForEach(grados, id: \.self) { grado in
                                ForEach(grupos, id: \.self) { grupo in
                                    Section(header: Text("Grado: \(grado), Grupo: \(grupo)").font(.headline).padding()) {
                                        ForEach(filteredStudents(forGrade: grado, andGroup: grupo)
                                            .sorted(by: { $0.name < $1.name })) { student in
                                                HStack {
                                                    VStack(alignment: .leading) {
                                                        Text("ID: \(student.idStudent) - \(student.name) \(student.lastName)")
                                                            .font(.headline)
                                                            .foregroundColor(.blue)
                                                        Text("Grado: \(student.grade) | Grupo: \(student.group) | Tel: \(student.phoneNumber)")
                                                            .font(.subheadline)
                                                            .foregroundColor(.gray)
                                                    }
                                                    Spacer()
                                                }
                                                .padding()
                                                .background(Color(.systemGray6)) // Fondo gris claro para cada fila de estudiante
                                                .cornerRadius(10)
                                                .shadow(radius: 5)
                                                .swipeActions(edge: .trailing) {
                                                    Button(role: .destructive) {
                                                        let dbStudentManager: DB_StudentManager = DB_StudentManager()
                                                        dbStudentManager.deleteStudent(idValue: student.idStudent)
                                                        self.studentModels = dbStudentManager.getStudents()
                                                    } label: {
                                                        Label("Eliminar", systemImage: "trash.fill")
                                                    }
                                                    .tint(.red)
                                                }
                                                .swipeActions(edge: .leading) {
                                                    Button {
                                                        self.selectedStudentId = student.idStudent
                                                        self.isEditing = true
                                                    } label: {
                                                        Label("Editar", systemImage: "pencil")
                                                    }
                                                    .tint(.orange)
                                                }
                                                .listRowBackground(Color.white) // Fondo blanco para la fila
                                            }
                                    }
                                }
                            }
                        }
                        .listStyle(InsetGroupedListStyle()) // Para un estilo moderno
                        .background(Color.white) // Fondo blanco para todo el List
                        .navigationTitle("Lista de Estudiantes")
                        
                        .navigationBarItems(trailing: NavigationLink(destination: AddStudentView()) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.blue)
                        })
                    }
                }
                .onAppear {
                    self.studentModels = DB_StudentManager().getStudents()
                }
            }
            .preferredColorScheme(.light) // Fuerza el modo claro en esta vista
        }
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // Función para filtrar estudiantes por grado, grupo y texto de búsqueda
    private func filteredStudents(forGrade grade: Int, andGroup group: String) -> [StudentModel] {
        return studentModels
            .filter { $0.grade == grade && $0.group == group }
            .filter {
                searchText.isEmpty ||
                ("\($0.name) \($0.lastName)").localizedCaseInsensitiveContains(searchText)
            }
    }
}
struct StudentListView_Previews: PreviewProvider {
    static var previews: some View {
        StudentListView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
