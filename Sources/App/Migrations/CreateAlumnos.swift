//
//  File.swift
//  
//
//  Created by Eduardo Martin Lorenzo on 3/6/22.
//

import Vapor
import Fluent

struct CreateAlumnos: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Alumno.schema)
            .field(.id, .int, .identifier(auto: true))
            .field(.nombre, .string, .required)
            .field(.apellidos, .string, .required)
            .field(.nacimiento, .date)
            .field(.empresa, .uuid, .references(Empresa.schema, .id, onDelete: .setNull))
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Alumno.schema)
            .delete()
    }
}
