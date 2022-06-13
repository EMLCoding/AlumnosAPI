//
//  File.swift
//  
//
//  Created by Eduardo Martin Lorenzo on 4/6/22.
//

import Vapor
import Fluent

struct EmpresaController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let empresa = routes.grouped("empresa")
        empresa.get(use: getEmpresas)
        empresa.post(use: createEmpresa)
        empresa.group(":empresaID") { empresaID in
            empresaID.get(use: getEmpresaByID)
            empresaID.put(use: updateEmpresa)
            empresaID.delete(use: deleteEmpresa)
            empresaID.get("alumnos", use: getAlumnosByEmpresa)
            empresaID.get(":nivelID", "formaciones", use: getFormacionesByEmpresaNivel)
        }
        
    }
    
    func getEmpresas(req: Request) async throws -> [Empresa] {
        try await Empresa
            .query(on: req.db)
            .all()
    }
    
    func getEmpresaByID(req: Request) async throws -> Empresa {
        guard let empresaID = req.parameters.get("empresaID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "El ID de la empresa no es correcto")
        }
        if let empresa = try await Empresa.find(empresaID, on: req.db) {
            return empresa
        } else {
            throw Abort(.notFound, reason: "No hay ninguna empresa con ese ID")
        }
    }
    
    func getAlumnosByEmpresa(req: Request) async throws -> [Alumno] {
        guard let id = req.parameters.get("empresaID", as: UUID.self) else { throw Abort(.notFound) }
        guard let empresa = try await Empresa.find(id, on: req.db) else { throw Abort(.notFound) }
        return try await empresa.$alumnosEmpresa
            .query(on: req.db)
            .all()
    }
    
    func createEmpresa(req: Request) async throws -> Response {
        let empresa = try req.content.decode(Empresa.self)
        if try await Empresa.query(on: req.db).filter(\.$direccion, .custom("ILIKE"), empresa.direccion).count() != 0 {
            throw Abort(.conflict, reason: "Ya existe una empresa en esa dirección")
        } else {
            try await empresa.create(on: req.db)
            return Response(status: .created)
        }
    }
    
    func updateEmpresa(req: Request) async throws -> Response {
        let empresa = try req.content.decode(Empresa.self)
        if try await Empresa.query(on: req.db).filter(\.$direccion, .custom("ILIKE"), empresa.direccion).count() != 0 {
            throw Abort(.conflict, reason: "Ya existe una empresa en esa dirección")
        } else {
            if let empresaToUpdate = try await Empresa.find(req.parameters.get("empresaID", as: UUID.self), on: req.db) {
                empresaToUpdate.direccion = empresa.direccion
                empresaToUpdate.contacto = empresa.contacto
                try await empresaToUpdate.update(on: req.db)
                return Response(status: .ok)
            } else {
                return Response(status: .notModified)
            }
        }
    }
    
    func deleteEmpresa(req: Request) async throws -> Response {
        guard let empresaID = req.parameters.get("empresaID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "El ID de la empresa no es correcto")
        }
        if let empresa = try await Empresa.find(empresaID, on: req.db) {
            try await empresa.delete(on: req.db)
            return Response(status: .accepted)
        } else {
            throw Abort(.notFound, reason: "Empresa no encontrada")
        }
    }
    
    
    /// Crea un endpoint con las formaciones que han realizado los alumnos de una empresa para un nivel concreto de formación.
    func getFormacionesByEmpresaNivel(req: Request) async throws -> [Formacion] {
        guard let empresaID = req.parameters.get("empresaID", as: UUID.self) else { throw Abort(.badRequest) }
        guard let nivelID = req.parameters.get("nivelID", as: UUID.self) else { throw Abort(.badRequest) }
        
        guard let empresa = try await Empresa.find(empresaID, on: req.db) else { throw Abort(.notFound) }
        let alumnos = try await empresa.$alumnosEmpresa
            .query(on: req.db)
            .all()
        
        var formaciones: [Formacion] = []
        
        for alumno in alumnos {
            let formacionesByAlumno = try await alumno.$formaciones
                .query(on: req.db)
                .filter(\.$nivel.$id == nivelID)
                .all()
            formaciones.append(contentsOf: formacionesByAlumno)
        }
        
        return formaciones
    }
}
