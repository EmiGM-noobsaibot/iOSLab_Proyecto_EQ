import Foundation
#if canImport(Combine)
import Combine
#endif

@MainActor
class AFIListViewModel: ObservableObject {
    // Arrays que mantienen el estado de los datos
    @Published var todosLosEventos: [Evento] = []
    @Published var misInscripciones: [Inscripcion] = []
    
    // Variables de estado visual
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // Filtro para los Tabs por Categoría en la interfaz AFI
    @Published var categoriaActiva: CategoriaAFI? = nil
    
    init() {}
    
    // MARK: - API de Cartelera General (Lectura Pública)
    
    /// Descarga absolutamente toda la cartelera de eventos disponibles
    func fetchCarteleraEventos() async {
        isLoading = true
        errorMessage = nil
        
        // Simulamos latencia de red
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        self.todosLosEventos = MockDatabase.shared.eventos
        
        isLoading = false
    }
    
    // MARK: - Filtros Computados Localmente
    
    /// Filtra y muestra la cartelera a partir de la Categoría seleccionada
    var carteleraFiltrada: [Evento] {
        guard let categoria = categoriaActiva else {
            return todosLosEventos 
        }
        return todosLosEventos.filter { $0.categoria == categoria }
    }
    
    // MARK: - Lógica de Alumno Privada (Mis Inscripciones)
    
    /// Descarga a qué eventos me he registrado
    func fetchMisActividades(matricula: Double) async {
        try? await Task.sleep(nanoseconds: 300_000_000)
        self.misInscripciones = MockDatabase.shared.inscripciones.filter { $0.alumnoId == matricula }
    }
    
    /// Motor: Acción para que el estudiante dé click en "Inscribirme"
    func inscribirmeAEvento(eventoId: Int, alumnoId: Double) async {
        errorMessage = nil
        
        // Verificar si ya está inscrito
        if misInscripciones.contains(where: { $0.eventoId == eventoId }) {
            return
        }
        
        let nueva = Inscripcion(id: UUID(), eventoId: eventoId, alumnoId: alumnoId, signedUpAt: Date().description, finalizada: false)
        MockDatabase.shared.inscripciones.append(nueva)
        
        await fetchMisActividades(matricula: alumnoId)
    }
    
    /// Motor: Lógica Crítica - Finalizar AFI
    func marcarAFIFinalizada(inscripcionId: UUID, _ status: Bool = true) async {
        if let index = MockDatabase.shared.inscripciones.firstIndex(where: { $0.id == inscripcionId }) {
            let vieja = MockDatabase.shared.inscripciones[index]
            let actualizada = Inscripcion(
                id: vieja.id, 
                eventoId: vieja.eventoId, 
                alumnoId: vieja.alumnoId, 
                signedUpAt: vieja.signedUpAt, 
                finalizada: status
            )
            MockDatabase.shared.inscripciones[index] = actualizada
            
            // Actualizar local
            if let localIndex = misInscripciones.firstIndex(where: { $0.id == inscripcionId }) {
                misInscripciones[localIndex] = actualizada
            }
        }
    }
    
    // MARK: - Contadores Oficiales Semestrales
    
    /// Revisa si un evento en la pantalla principal ya está inscrito
    func isEventoInscrito(eventoId: Int) -> Bool {
        return misInscripciones.contains(where: { $0.eventoId == eventoId })
    }
    
    /// Contador crítico de la meta 14 semestral
    var totalAfiCompletadasMismoSemestre: Int {
        return misInscripciones.filter { $0.finalizada == true }.count
    }
}
