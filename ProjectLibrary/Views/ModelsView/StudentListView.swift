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
    @State private var searchText: String = ""
    
    var grupos: [String] = ["A", "B", "C"]
    var grados: [Int] = Array(1...6)
    
    var body: some View {
        NavigationView {
            ZStack {
                // Fondo degradado
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                NavigationLink(destination: EditStudentView(idStudent: self.$selectedStudentId), isActive: self.$isEditing) {
                    EmptyView()
                }
                
                VStack(alignment: .center) {
                    Spacer().frame(height: 20) // Espacio adicional para separar del icono de menú

                    // Título de la lista centrado
                    Text("Lista de Estudiantes")
                        .font(.custom("AvenirNext-Bold", size: 35))
                        .padding(.bottom, 10)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    // Campo de búsqueda
                    TextField("Buscar estudiante por nombre...", text: $searchText)
                        .padding(10)
                        .font(.custom("AvenirNext-Regular", size: 18))
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .onChange(of: searchText) { _ in
                            self.studentModels = DB_StudentManager().getStudents()
                        }
                    
                    VStack(spacing: 10) {
                        List {
                            if searchText.isEmpty {
                                // Mostrar estudiantes por grado y grupo si no hay búsqueda
                                ForEach(grados, id: \.self) { grado in
                                    ForEach(grupos, id: \.self) { grupo in
                                        Section(header: Text("Grado: \(grado), Grupo: \(grupo)")
                                                    .font(.custom("AvenirNext-Bold", size: 18))
                                                    .foregroundColor(.blue)
                                                    .padding(.vertical)) {
                                            ForEach(filteredStudents(forGrade: grado, andGroup: grupo)
                                                .sorted(by: { $0.name < $1.name })) { student in
                                                    StudentRowView(student: student)
                                                }
                                        }
                                    }
                                }
                            } else {
                                // Mostrar resultados de búsqueda por nombre
                                ForEach(filteredStudentsByName().sorted(by: { $0.name < $1.name })) { student in
                                    StudentRowView(student: student)
                                }
                            }
                        }
                        .listStyle(InsetGroupedListStyle())
                        .background(Color.clear)
                        
                        .navigationBarItems(trailing: VStack {
                            Spacer().frame(height: 20) // Agrega espacio superior para bajar el botón
                            NavigationLink(destination: AddStudentView()) {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.blue)
                            }
                        })
                    }
                }
                .onAppear {
                    self.studentModels = DB_StudentManager().getStudents()
                }
            }
            .preferredColorScheme(.light)
        }
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // Función para filtrar estudiantes por grado y grupo
    private func filteredStudents(forGrade grade: Int, andGroup group: String) -> [StudentModel] {
        return studentModels
            .filter { $0.grade == grade && $0.group == group }
    }
    
    // Función para filtrar estudiantes solo por nombre
    private func filteredStudentsByName() -> [StudentModel] {
        return studentModels
            .filter {
                ("\($0.name) \($0.lastName)").localizedCaseInsensitiveContains(searchText)
            }
    }
}

struct StudentRowView: View {
    var student: StudentModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("ID: \(student.idStudent) - \(student.name) \(student.lastName)")
                    .font(.custom("AvenirNext-Bold", size: 16))
                    .foregroundColor(.blue)
                
                Text("Grado: \(student.grade) | Grupo: \(student.group) | Tel: \(student.phoneNumber)")
                    .font(.custom("AvenirNext-Regular", size: 14))
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .cornerRadius(10)
        .shadow(radius: 5)
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                let dbStudentManager: DB_StudentManager = DB_StudentManager()
                dbStudentManager.deleteStudent(idValue: student.idStudent)
                // Actualizar lista después de eliminar
            } label: {
                Label("Eliminar", systemImage: "trash.fill")
            }
            .tint(.red)
        }
        .swipeActions(edge: .leading) {
            Button {
                // Lógica para editar estudiante
            } label: {
                Label("Editar", systemImage: "pencil")
            }
            .tint(.orange)
        }
    }
}


struct StudentListView_Previews: PreviewProvider {
    static var previews: some View {
        StudentListView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
