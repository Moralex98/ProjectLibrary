//
//  EditBookView.swift
//  MyProjectLibrary
//
//  Created by Freddy Morales on 17/09/24.
//

import SwiftUI

struct EditBookView: View {
    @Binding var isbn: Int64
    
    @State var nameBook: String = ""
    @State var author: String = ""
    @State var editorial: String = ""
    @State var edition: String = ""
    @State var category: String = ""
    @State var numberBooks: String = ""
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    let categories: [String] = ["Educativo", "Ficción", "Fantasia", "Libros Ilustrados"]
    
    var body: some View {
        ZStack {
            // Fondo degradado
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 25) {
                HStack {
                    TextField("Ingresa el nombre del libro", text: $nameBook)
                        .padding(15)
                        .frame(width: 500) // Ancho ajustado
                        .background(Color(.systemGray6))
                        .cornerRadius(5)
                        .font(.custom("Avenir Next", size: 30)) // Fuente estilizada
                        .disableAutocorrection(true)
                        .onChange(of: nameBook) { newValue in
                            self.nameBook = newValue.capitalized
                        }
                    
                    TextField("Ingresa el autor", text: $author)
                        .padding(15)
                        .frame(width: 500) // Ancho ajustado
                        .background(Color(.systemGray6))
                        .cornerRadius(5)
                        .font(.custom("Avenir Next", size: 30)) // Fuente estilizada
                        .disableAutocorrection(true)
                        .onChange(of: author) { newValue in
                            self.author = newValue.capitalized
                        }
                }
                
                TextField("Ingresa la editorial", text: $editorial)
                    .padding(15)
                    .frame(width: 500) // Ancho ajustado
                    .background(Color(.systemGray6))
                    .cornerRadius(5)
                    .font(.custom("Avenir Next", size: 30)) // Fuente estilizada
                    .disableAutocorrection(true)
                    .onChange(of: editorial) { newValue in
                        self.editorial = newValue.capitalized
                    }
                
                HStack {
                    TextField("Ingresa el año de la edición", text: $edition)
                        .keyboardType(.numberPad)
                        .padding(15)
                        .frame(width: 500) // Ancho ajustado
                        .background(Color(.systemGray6))
                        .cornerRadius(5)
                        .font(.custom("Avenir Next", size: 30)) // Fuente estilizada
                        .disableAutocorrection(true)
                    
                    TextField("Ingresa la cantidad de libros", text: $numberBooks)
                        .keyboardType(.numberPad)
                        .padding(15)
                        .frame(width: 500) // Ancho ajustado
                        .background(Color(.systemGray6))
                        .cornerRadius(5)
                        .font(.custom("Avenir Next", size: 30)) // Fuente estilizada
                        .disableAutocorrection(true)
                }
                
                VStack(alignment: .center, spacing: 20) {
                    HStack {
                        Text("Selecciona una categoría del libro: ")
                        Text(category)
                    }
                    .font(.custom("Avenir Next", size: 30))
                    
                    Picker("", selection: $category) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 100)
                }
                
                Button(action: {
                    // Llamar a la función para actualizar el libro en la base de datos
                    DB_BookManager().updateBook(
                        isbnValue: self.isbn,
                        nameValue: self.nameBook,
                        authorValue: self.author,
                        editorialValue: self.editorial,
                        editionValue: Int64(self.edition) ?? 0,
                        categoryValue: self.category,
                        numberBookValue: Int64(self.numberBooks) ?? 0
                    )
                    // Regresar a la vista anterior
                    self.mode.wrappedValue.dismiss()
                }, label: {
                    Text("Editar Libro")
                        .padding()
                        .background(Color.purple.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.custom("Avenir Next", size: 30))
                })
                .padding(.top)
            }
            .padding()
            .onAppear {
                if let bookModel = DB_BookManager().getBook(isbnValue: self.isbn) {
                    self.nameBook = bookModel.nameBook
                    self.author = bookModel.author
                    self.editorial = bookModel.editorial
                    self.edition = String(bookModel.edition)
                    self.category = bookModel.category
                    self.numberBooks = String(bookModel.numberBooks)
                } else {
                    print("No se encontró el libro con ISBN: \(self.isbn)")
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .preferredColorScheme(.light)
    }
}

struct EditBookView_Previews: PreviewProvider {
    @State static var isbn: Int64 = 0
    
    static var previews: some View {
        EditBookView(isbn: $isbn)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
