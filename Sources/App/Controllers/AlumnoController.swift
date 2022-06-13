//
//  File.swift
//  
//
//  Created by Eduardo Martin Lorenzo on 4/6/22.
//

import Vapor
import Fluent

struct AlumnoController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let alumno = routes.grouped("alumno")
        alumno.get(use: getAlumnos)
        alumno.post(use: createAlumno)
        alumno.group(":alumnoID") { alumnoID in
            alumnoID.get(use: getAlumnoByID)
            alumnoID.get("formaciones", use: getFormacionesByAlumno)
            alumnoID.put(use: updateAlumno)
            alumnoID.delete(use: deleteAlumno)
        }
    }
    
    func getAlumnos(req: Request) async throws -> [Alumno] {
        try await Alumno
            .query(on: req.db)
            .with(\.$empresa)
            .all()
    }
    
    func getAlumnoByID(req: Request) async throws -> Alumno {
        guard let alumnoID = req.parameters.get("alumnoID", as: Int.self) else {
            throw Abort(.badRequest, reason: "El ID del alumno no es correcto")
        }
        if let alumno = try await Alumno.find(alumnoID, on: req.db) {
            try await alumno.$empresa.load(on: req.db)
            return alumno
        } else {
            throw Abort(.notFound, reason: "No existe un alumno con ese ID")
        }
    }
    
    func getFormacionesByAlumno(req: Request) async throws -> [Formacion] {
        guard let id = req.parameters.get("alumnoID", as: Int.self) else { throw Abort(.notFound) }
        guard let alumno = try await Alumno.find(id, on: req.db) else { throw Abort(.notFound) }
        return try await alumno.$formaciones
            .query(on: req.db)
            .with(\.$nivel)
            .all()
    }
    
    func createAlumno(req: Request) async throws -> Response {
        let alumno = try req.content.decode(Alumno.self)
        try await alumno.create(on: req.db)
        return Response(status: .created)
    }
    
    func updateAlumno(req: Request) async throws -> Response {
        guard let id = req.parameters.get("alumnoID", as: Int.self),
              let alumno = try await Alumno.find(id, on: req.db) else { throw Abort(.badRequest) }
        let update = try req.content.decode(UpdateAlumno.self)
        if let nombre = update.nombre, nombre != alumno.nombre {
            alumno.nombre = nombre
        }
        if let apellidos = update.apellidos, apellidos != alumno.apellidos {
            alumno.apellidos = apellidos
        }
        if let nacimiento = update.nacimiento, nacimiento != alumno.nacimiento {
            alumno.nacimiento = nacimiento
        }
        if let empresa = update.empresa, empresa != alumno.$empresa.id {
            guard try await Empresa.find(empresa, on: req.db) != nil else {
                throw Abort(.notFound, reason: "Empresa no encontrado.")
            }
            alumno.$empresa.id = empresa
        }
        
        try await alumno.update(on: req.db)
        return Response(status: .ok)
        
    }
    
    func deleteAlumno(req: Request) async throws -> Response {
        guard let alumnoID = req.parameters.get("alumnoID", as: Int.self) else {
            throw Abort(.badRequest, reason: "El ID del alumno no es correcto")
        }
        if let alumno = try await Alumno.find(alumnoID, on: req.db) {
            try await alumno.delete(on: req.db)
            return Response(status: .accepted)
        } else {
            throw Abort(.notFound, reason: "Alumno no encontrado")
        }
    }
    
}
