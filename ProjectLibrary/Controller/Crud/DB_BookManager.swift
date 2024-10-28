//
//  DB_BookManager.swift
//  MyProjectLibrary
//
//  Created by Freddy Morales on 17/09/24.
//

import Foundation
import SQLite

class DB_BookManager {
    private let db: Connection
    
    private let books: Table
    
    // Columnas
    private let isbn: Expression<Int64>!
    private let nameBook: Expression<String>!
    private let author: Expression<String>!
    private let editorial: Expression<String>!
    private let edition: Expression<Int64>!
    private let category: Expression<String>!
    private let numberBooks: Expression<Int64>!
    
    init() {
        db = DBManager.shared.getConnection()
        
        books = Table("books")
        isbn = Expression<Int64>("isbn") // ISBN como clave primaria
        nameBook = Expression<String>("name_book")
        author = Expression<String>("author")
        editorial = Expression<String>("editorial")
        edition = Expression<Int64>("edition")
        category = Expression<String>("categoria")
        numberBooks = Expression<Int64>("number_books")
        
        do {
            try createTablesIfNeeded()
        } catch {
            print("Error al crear las tablas: \(error.localizedDescription)")
        }
    }
    
    public func createTablesIfNeeded() throws {
        try db.run(books.create(ifNotExists: true) { t in
            t.column(isbn, primaryKey: true) // ISBN como clave primaria
            t.column(nameBook)
            t.column(author)
            t.column(editorial)
            t.column(edition)
            t.column(category)
            t.column(numberBooks)
        })
    }
       
    // Método para verificar si un ISBN ya está registrado
    public func isISBNRegistered(isbnValue: Int64) -> Bool {
        do {
            let query = books.filter(isbn == isbnValue)
            if try db.pluck(query) != nil {
                return true // ISBN ya existe
            }
        } catch {
            print("Error al verificar ISBN: \(error.localizedDescription)")
        }
        return false
    }
       
    // Método para añadir un nuevo libro
    public func addBook(isbnValue: Int64, nameValue: String, authorValue: String, editorialValue: String, editionValue: Int64, categoryValue: String, numberBookValue: Int64) {
        do {
            // Inserta un nuevo libro si el ISBN no está registrado
            try db.run(books.insert(
                isbn <- isbnValue,
                nameBook <- nameValue,
                author <- authorValue,
                editorial <- editorialValue,
                edition <- editionValue,
                category <- categoryValue,
                numberBooks <- numberBookValue
            ))
            print("Libro agregado correctamente: \(nameValue)")
        } catch {
            print("Error al agregar libro: \(error.localizedDescription)")
        }
    }
       
    // Método para obtener la lista completa de libros
    public func getBooks() -> [BooksModel] {
        var bookModels: [BooksModel] = []
           
        do {
            // Obtiene todos los libros y los ordena por ISBN de forma descendente
            for book in try db.prepare(books.order(isbn.desc)) {
                let bookModel = BooksModel()
                bookModel.isbn = book[isbn]
                bookModel.nameBook = book[nameBook]
                bookModel.author = book[author]
                bookModel.editorial = book[editorial]
                bookModel.edition = book[edition]
                bookModel.category = book[category]
                bookModel.numberBooks = book[numberBooks]
                   
                bookModels.append(bookModel)
            }
            print("Total libros recuperados: \(bookModels.count)")
        } catch {
            print("Error al obtener libros: \(error.localizedDescription)")
        }
        return bookModels
    }
       
    // Método para obtener un libro específico por ISBN
    public func getBook(isbnValue: Int64) -> BooksModel? {
        let bookModel = BooksModel()
           
        do {
            // Filtra por ISBN
            let query = books.filter(isbn == isbnValue)
            if let book = try db.pluck(query) {
                bookModel.isbn = book[isbn]
                bookModel.nameBook = book[nameBook]
                bookModel.author = book[author]
                bookModel.editorial = book[editorial]
                bookModel.edition = book[edition]
                bookModel.category = book[category]
                bookModel.numberBooks = book[numberBooks]
                   
                return bookModel
            } else {
                print("No se encontró el libro con ISBN: \(isbnValue)")
                return nil
            }
        } catch {
            print("Error al obtener el libro: \(error.localizedDescription)")
            return nil
        }
    }
    public func updateBook(isbnValue: Int64, nameValue: String, authorValue: String, editorialValue: String, editionValue: Int64, categoryValue: String, numberBookValue: Int64) {
            do {
                let book = books.filter(isbn == isbnValue)
                
                try db.run(book.update(nameBook <- nameValue, author <- authorValue, editorial <- editorialValue, edition <- editionValue, category <- categoryValue, numberBooks <- numberBookValue))
            } catch {
                print("Error al actualizar el libro: \(error.localizedDescription)")
            }
        }
    
    // Método para actualizar la cantidad de libros
    public func updateBookQuantity(isbnValue: Int64, delta: Int64) {
        do {
            // Encuentra el libro por ISBN y actualiza la cantidad
            let book = books.filter(isbn == isbnValue)
            if let existingBook = try db.pluck(book) {
                let newQuantity = existingBook[numberBooks] + delta
                try db.run(book.update(numberBooks <- newQuantity))
                print("Cantidad de libros actualizada exitosamente.")
            }
        } catch {
            print("Error al actualizar la cantidad de libros: \(error.localizedDescription)")
        }
    }
       
    // Método para eliminar un libro
    public func deleteBook(isbnValue: Int64) {
        do {
            let book = books.filter(isbn == isbnValue)
            try db.run(book.delete())
            print("Libro eliminado exitosamente.")
        } catch {
            print("Error al eliminar el libro: \(error.localizedDescription)")
        }
    }
}
