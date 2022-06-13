//
//  File.swift
//  
//
//  Created by Eduardo Martin Lorenzo on 4/6/22.
//

import Vapor
import Fluent

struct FormacionController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let formacion = routes.grouped("formacion")
        formacion.get(use: getFormaciones)
        formacion.post(use: createFormacion)
        formacion.post("addAlumnos", use: assignAlumnos)
        formacion.group(":formacionID") { formacionID in
            formacionID.get(use: getFormacionByID)
            formacionID.get("alumnos", use: getAlumnosByFormacion)
        }
    }
    
    func getFormaciones(req: Request) async throws -> [Formacion] {
        try await Formacion
            .query(on: req.db)
            .with(\.$nivel)
            .all()
    }
    
    func getFormacionByID(req: Request) async throws -> Formacion {
        guard let formacionID = req.parameters.get("formacionID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "El ID de la formacion no es correcto")
        }
        if let formacion = try await Formacion.find(formacionID, on: req.db) {
            try await formacion.$nivel.load(on: req.db)
            return formacion
        } else {
            throw Abort(.notFound, reason: "No existe una formacion con ese ID")
        }
    }
    
    func getAlumnosByFormacion(req: Request) async throws -> [Alumno] {
        guard let id = req.parameters.get("formacionID", as: UUID.self) else { throw Abort(.notFound) }
        guard let formacion = try await Formacion.find(id, on: req.db) else { throw Abort(.notFound) }
        return try await formacion.$alumnos
            .query(on: req.db)
            .with(\.$empresa)
            .all()
    }
    
    func createFormacion(req: Request) async throws -> Response {
        let formacion = try req.content.decode(Formacion.self)
        try await formacion.create(on: req.db)
        return Response(status: .created)
    }
    
    func assignAlumnos(req: Request) async throws -> Response {
        let content = try req.content.decode(AddFormacionAlumnos.self)
        guard let formacion = try await Formacion.find(content.formacionID, on: req.db) else {
            throw Abort(.notFound)
        }
        for id in content.alumnos {
            if let alumno = try await Alumno.find(id, on: req.db) {
                try await formacion.$alumnos.attach(alumno, method: .ifNotExists, on:req.db)
            }
        }
        return Response(status: .ok)
    }
}
