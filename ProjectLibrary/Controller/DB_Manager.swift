//
//  DB_Manager.swift
//  MyProjectLibrary
//
//  Created by Freddy Morales on 17/09/24.
//

import SQLite // Cambia SQLite3 por SQLite (de SQLite.swift)
import Foundation

class DBManager {
    // Conexión única a la base de datos
    static let shared = DBManager()

    private var db: Connection!

    private init() {
        do {
            // Usar FileManager para obtener la ruta del directorio de documentos
            let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let dbPath = documentsDirectory.appendingPathComponent("library.sqlite3").path
            
            db = try Connection(dbPath)
            print("Database path: \(dbPath)")
        } catch {
            print("Error al conectar a la base de datos: \(error.localizedDescription)")
        }
    }

    func getConnection() -> Connection {
        return db
    }
}
