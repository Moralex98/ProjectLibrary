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
                    return true
                }
            } catch {
                print("Error al verificar ISBN: \(error.localizedDescription)")
            }
            return false
        }
    // Método para verificar si un ISBN NO está registrado
        public func isISBNNotRegistered(isbnValue: Int64) -> Bool {
            return !isISBNRegistered(isbnValue: isbnValue)
        }
    // crear registro
    public func addBook(isbnValue: Int64, nameValue: String, authorValue: String, editorialValue: String, editionValue: Int64, categoryValue: String, numberBookValue: Int64) {
        do {
            try db.run(books.insert(isbn <- isbnValue, nameBook <- nameValue, author <- authorValue, editorial <- editorialValue, edition <- editionValue, category <- categoryValue, numberBooks <- numberBookValue))
            print("Agregado: \(nameValue) por \(authorValue)")
        } catch {
            print("Error al agregar libro: \(error.localizedDescription)")
        }
    }
    
    public func getBooks() -> [BooksModel] {
        var bookModels: [BooksModel] = []
        
        do {
            for book in try db.prepare(books.order(isbn.desc)) {
                let bookModel = BooksModel()
                bookModel.isbn = book[isbn]
                bookModel.nameBook = book[nameBook]
                bookModel.author = book[author]
                bookModel.editorial = book[editorial]
                bookModel.edition = book[edition]
                bookModel.category = book[category]
                bookModel.numberBooks = book[numberBooks]
                
                print("Libros: \(bookModel.isbn), \(bookModel.nameBook)")
                
                bookModels.append(bookModel)
            }
            print("Total libros recuperados: \(bookModels.count)")
        } catch {
            print("Error al obtener libros: \(error.localizedDescription)")
        }
        
        return bookModels
    }
    
    public func getBook(isbnValue: Int64) -> BooksModel? {
        let bookModel = BooksModel()
        
        do {
            let query = books.filter(isbn == isbnValue)
            if let book = try db.pluck(query) {
                bookModel.isbn = book[isbn]
                bookModel.nameBook = book[nameBook]
                bookModel.author = book[author]
                bookModel.editorial = book[editorial]
                bookModel.edition = book[edition]
                bookModel.category = book[category]
                bookModel.numberBooks = book[numberBooks]
                
                print("Libro encontrado: \(bookModel.isbn), \(bookModel.nameBook)")
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
    
    public func deleteBook(isbnValue: Int64) {
        do {
            let book = books.filter(isbn == isbnValue)
            
            try db.run(book.delete())
        } catch {
            print("Error al eliminar el libro: \(error.localizedDescription)")
        }
    }
}
