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
    
    let categories: [String] = ["Cuentos de Animales", "Educativo", "Ficción", "Fantasia", "Libros Ilustrados"]
    
    var body: some View {
        ZStack {
            // Fondo de la vista principal
            Color.white
                .edgesIgnoringSafeArea(.all) // Hace que el fondo cubra toda la pantalla
            
            VStack (spacing: 25) {
                HStack {
                    TextField("Ingresa el nombre del libro", text: $nameBook)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(5)
                        .disableAutocorrection(true)
                        .onChange(of: nameBook) { newValue in
                            self.nameBook = newValue.capitalized
                        }
                    
                    TextField("Ingresa el autor", text: $author)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(5)
                        .disableAutocorrection(true)
                        .onChange(of: author) { newValue in
                            self.author = newValue.capitalized
                        }
                }
                
                TextField("Ingresa la editorial", text: $editorial)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(5)
                    .disableAutocorrection(true)
                    .onChange(of: editorial) { newValue in
                        self.editorial = newValue.capitalized
                    }
                
                HStack {
                    TextField("Ingresa el año de la edición", text: $edition)
                        .keyboardType(.numberPad)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(5)
                        .disableAutocorrection(true)
                    
                    TextField("Ingresa la cantidad de libros", text: $numberBooks)
                        .keyboardType(.numberPad)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(5)
                        .disableAutocorrection(true)
                }
                
                VStack(alignment: .center, spacing: 20) {
                    HStack {
                        Text("Selecciona una categoría del libro: ")
                        Text(category)
                    }
                    .cornerRadius(10)
                    .font(.title.bold())
                    
                    Picker("", selection: $category) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                                .font(.title.bold())
                                .foregroundColor(.blue)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())  // Estilo de rueda para el Picker
                    .frame(height: 100)              // Ajusta la altura del Picker
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
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                })
                .padding(.top)
                .font(.title)
            }
            .padding()
            .onAppear {
                if let bookModel = DB_BookManager().getBook(isbnValue: self.isbn) {
                    // Poblar los campos de texto con los datos del libro
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
        .ignoresSafeArea(.keyboard, edges: .bottom) // Evita que el teclado empuje la vista
        .preferredColorScheme(.light) // Fuerza el modo claro en esta vista
    }
}

struct EditBookView_Previews: PreviewProvider {
    @State static var isbn: Int64 = 0
    
    static var previews: some View {
        EditBookView(isbn: $isbn)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
