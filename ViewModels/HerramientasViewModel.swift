import Foundation
#if canImport(Combine)
import Combine
#endif

@MainActor
class HerramientasViewModel: ObservableObject {
    @Published var notas: [RecordatorioPersonal] = []
    @Published var alarmas: [Alarma] = []
    @Published var isLoading = false
    
    // UUID / Matrícula desde el Auth global
    var matriculaAlumno: Double? = nil 
    
    init() {}
    
    func fetchHerramientas() async {
        guard let matricula = matriculaAlumno else { return }
        isLoading = true
        
        try? await Task.sleep(nanoseconds: 300_000_000)
        
        // Simular lectura de BD local
        self.notas = MockDatabase.shared.recordatorios
            .filter { $0.usuarioId == matricula }
            .sorted { ($0.createdAt ?? "") > ($1.createdAt ?? "") }
            
        self.alarmas = MockDatabase.shared.alarmas
            .filter { $0.usuarioId == matricula }
            
        isLoading = false
    }
    
    /// Inserta una nueva nota
    func crearNotaRapida(titulo: String, descripcion: String, prioridad: PriorityLevel) async {
        guard let matricula = matriculaAlumno else { return }
        
        let nueva = RecordatorioPersonal(
            id: UUID(),
            usuarioId: matricula,
            titulo: titulo,
            nota: descripcion,
            prioridad: prioridad,
            fechaRecordatorio: nil,
            horaRecordatorio: nil,
            createdAt: Date().description
        )
        
        MockDatabase.shared.recordatorios.append(nueva)
        await fetchHerramientas() // Refresca lista
    }
    
    // Función de exportación
    func procesarHoraParaDB(horaNative: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: horaNative)
    }
    
    /// Crea y guarda una Alarma personal
    func crearAlarma(titulo: String, hora: Date) async {
        guard let matricula = matriculaAlumno else { return }
        
        let horaFormat = procesarHoraParaDB(horaNative: hora)
        
        let nueva = Alarma(
            id: UUID(),
            usuarioId: matricula,
            titulo: titulo.isEmpty ? "Alarma" : titulo,
            hora: horaFormat,
            fecha: nil,
            activa: true
        )
        
        MockDatabase.shared.alarmas.append(nueva)
        await fetchHerramientas() // Actualiza inmediatamente la pantalla
    }
}
