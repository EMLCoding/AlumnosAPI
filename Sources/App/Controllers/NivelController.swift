//
//  File.swift
//  
//
//  Created by Eduardo Martin Lorenzo on 3/6/22.
//

import Vapor
import Fluent
import Foundation

struct NivelController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let nivel = routes.grouped("nivel")
        nivel.get(use: getNiveles)
        nivel.post(use: createNivel)
        nivel.group(":nivelID") { nivelID in
            nivelID.get(use: getNivelById)
            nivelID.put(use: updateNivel)
            nivelID.delete(use: deleteNivel)
        }
    }
    
    func getNiveles(req: Request) async throws -> [Nivel] {
        try await Nivel
            .query(on: req.db)
            .all()
    }
    
    func getNivelById(req: Request) async throws -> Nivel {
        guard let nivelID = req.parameters.get("nivelID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "El ID del nivel no es correcto")
        }
        if let nivel = try await Nivel.find(nivelID, on: req.db) {
            return nivel
        } else {
            throw Abort(.notFound, reason: "No existe un nivel con ese ID")
        }
    }
    
    func createNivel(req: Request) async throws -> Response {
        let nivel = try req.content.decode(Nivel.self)
        if try await Nivel.query(on: req.db).filter(\.$nombre, .custom("ILIKE"), nivel.nombre).count() != 0 {
            throw Abort(.conflict, reason: "Ya existe un nivel con el mismo nombre")
        } else {
            try await nivel.create(on: req.db)
            return Response(status: .created)
        }
    }
    
    func updateNivel(req: Request) async throws -> Response {
        let nivel = try req.content.decode(Nivel.self)
        if try await Nivel.query(on: req.db).filter(\.$nombre, .custom("ILIKE"), nivel.nombre).count() != 0 {
            throw Abort(.conflict, reason: "Ya existe un nivel con el mismo nombre")
        } else {
            if let nivelToUpdate = try await Nivel.find(req.parameters.get("nivelID", as: UUID.self), on: req.db) {
                nivelToUpdate.nombre = nivel.nombre
                try await nivelToUpdate.update(on: req.db)
                return Response(status: .ok)
            } else {
                return Response(status: .notModified)
            }
        }
    }
    
    func deleteNivel(req: Request) async throws -> Response {
        guard let nivelID = req.parameters.get("nivelID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "El ID del nivel no es correcto")
        }
        if let nivel = try await Nivel.find(nivelID, on: req.db) {
            try await nivel.delete(on: req.db)
            return Response(status: .accepted)
        } else {
            throw Abort(.notFound, reason: "Nivel no encontrado")
        }
    }
}
