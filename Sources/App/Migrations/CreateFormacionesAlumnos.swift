//
//  File.swift
//  
//
//  Created by Eduardo Martin Lorenzo on 3/6/22.
//

import Vapor
import Fluent

struct CreateFormacionesAlumnos: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(FormacionesAlumnos.schema)
            .id()
            .field(.alumnoID, .int, .required, .references(Alumno.schema, .id))
            .field(.formacionID, .uuid, .required, .references(Formacion.schema, .id))
            .unique(on: .alumnoID, .formacionID)
            .create()
    }
    
    func revert(on database: Database) async throws {
        
    }
}
