import Fluent
import Vapor

func routes(_ app: Application) throws {
    try app.group("api") { api in
        try api.register(collection: NivelController())
        try api.register(collection: EmpresaController())
        try api.register(collection: AlumnoController())
        try api.register(collection: FormacionController())
    }
}
