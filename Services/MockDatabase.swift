import Foundation

class MockDatabase {
    static let shared = MockDatabase()
    
    var eventos: [Evento] = []
    var inscripciones: [Inscripcion] = []
    var alarmas: [Alarma] = []
    var recordatorios: [RecordatorioPersonal] = []
    
    // Matrícula simulada del usuario actual
    let currentUserId: Double = 1234567.0
    
    private init() {
        // Datos de prueba (Mock Data)
        eventos = [
            Evento(id: 1, fechaEvento: "2024-10-15", nombreEvento: "Conferencia de Inteligencia Artificial", lugar: "Auditorio Principal FIME", aforo: 150, departamentoSolicitante: "Sistemas", horaInicio: "10:00:00", horaFin: "12:00:00", telefonoResponsable: "8181818181", insumos: nil, organizadorId: 999.0, categoria: .academicas, imageUrl: nil, estado: "publicado", descripcion: "Introducción a la Inteligencia Artificial y su impacto en la ingeniería moderna."),
            Evento(id: 2, fechaEvento: "2024-10-20", nombreEvento: "Torneo de Ajedrez", lugar: "Biblioteca Central", aforo: 50, departamentoSolicitante: "Deportes", horaInicio: "15:00:00", horaFin: "18:00:00", telefonoResponsable: "8181818182", insumos: nil, organizadorId: 999.0, categoria: .deportivas, imageUrl: nil, estado: "publicado", descripcion: "Torneo intrauniversitario de ajedrez rápido."),
            Evento(id: 3, fechaEvento: "2024-11-05", nombreEvento: "Exposición de Arte", lugar: "Explanada de Rectoría", aforo: 300, departamentoSolicitante: "Cultura", horaInicio: "11:00:00", horaFin: "14:00:00", telefonoResponsable: "8181818183", insumos: nil, organizadorId: 999.0, categoria: .culturales, imageUrl: nil, estado: "publicado", descripcion: "Exposición de obras realizadas por alumnos de la Facultad de Artes Visuales."),
            Evento(id: 4, fechaEvento: "2024-11-10", nombreEvento: "Hackathon 2024", lugar: "Polideportivo FIME", aforo: 500, departamentoSolicitante: "Innovación", horaInicio: "08:00:00", horaFin: "20:00:00", telefonoResponsable: "8181818184", insumos: nil, organizadorId: 999.0, categoria: .innovacionYEmprendimiento, imageUrl: nil, estado: "publicado", descripcion: "Compite con tu equipo para crear la mejor solución tecnológica en 12 horas."),
            Evento(id: 5, fechaEvento: "2024-11-15", nombreEvento: "Feria de Ciencias", lugar: "Facultad de Ciencias Químicas", aforo: 200, departamentoSolicitante: "Investigación", horaInicio: "09:00:00", horaFin: "13:00:00", telefonoResponsable: "8181818185", insumos: nil, organizadorId: 999.0, categoria: .investigacion, imageUrl: nil, estado: "publicado", descripcion: "Demostración de proyectos de investigación científica realizados por alumnos.")
        ]
        
        inscripciones = [
            Inscripcion(id: UUID(), eventoId: 1, alumnoId: currentUserId, signedUpAt: "2024-10-01T10:00:00Z", finalizada: true)
        ]
        
        alarmas = [
            Alarma(id: UUID(), usuarioId: currentUserId, titulo: "Despertar temprano para AFI", hora: "07:00:00", fecha: "2024-10-15", activa: true)
        ]
        
        recordatorios = [
            RecordatorioPersonal(id: UUID(), usuarioId: currentUserId, titulo: "Entregar proyecto final", nota: "No olvidar subir el archivo comprimido a la plataforma Nexus antes de medianoche.", prioridad: .urgente, fechaRecordatorio: "2024-10-14", horaRecordatorio: "23:59:00", createdAt: "2024-10-01T12:00:00Z")
        ]
    }
}
