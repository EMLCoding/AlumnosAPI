//
//  File.swift
//  
//
//  Created by Eduardo Martin Lorenzo on 3/6/22.
//

import Vapor
import Fluent

struct CreateNiveles: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Nivel.schema)
            .id()
            .field(.nombre, .string, .required)
            .unique(on: .nombre)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Nivel.schema)
            .delete()
    }
}
