//
//  File.swift
//  
//
//  Created by Eduardo Martin Lorenzo on 3/6/22.
//

import Vapor
import Fluent

struct CreateFormaciones: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Formacion.schema)
            .id()
            .field(.nombre, .string, .required)
            .field(.duracion, .int, .required)
            .field(.fechaInicio, .date, .required)
            .field(.nivel, .uuid, .references(Nivel.schema, .id, onDelete: .setNull), .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Formacion.schema)
            .delete()
    }
}
