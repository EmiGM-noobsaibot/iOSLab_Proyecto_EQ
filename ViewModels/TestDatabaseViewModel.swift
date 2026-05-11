import Foundation
#if canImport(Combine)
import Combine
#endif

@MainActor
class TestDatabaseViewModel: ObservableObject {
    @Published var eventos: [Evento] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    init() {}
    
    /// Esta función intentará conectarse a Supabase y descargar todos los eventos al modelo Swift
    func fetchEventos() async {
        isLoading = true
        errorMessage = nil
        do {
            print("🚀 Iniciando petición a la BD Mock...")
            
            try await Task.sleep(nanoseconds: 500_000_000)
            let response = MockDatabase.shared.eventos
            
            self.eventos = response
            print("✅ ¡Éxito! Se descargaron \(response.count) eventos de prueba.")
        } catch {
            print("❌ Error de Conexión: \(error)")
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
