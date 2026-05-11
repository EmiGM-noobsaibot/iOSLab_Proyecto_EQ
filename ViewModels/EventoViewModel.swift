import Foundation
#if canImport(Combine)
import Combine
#endif

@MainActor
class EventoViewModel: ObservableObject {
    @Published var nombreEvento: String = ""
    @Published var categoria: CategoriaAFI = .culturales
    @Published var fechaEvento: Date = Date()
    @Published var horaInicio: Date = Date()
    @Published var horaFin: Date = Date().addingTimeInterval(3600) // 1 hora de duracion por defecto
    @Published var lugar: String = ""
    @Published var aforoTexto: String = ""
    @Published var descripcion: String = ""
    @Published var telefonoResponsable: String = ""
    @Published var departamentoSolicitante: String = ""
    
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var isSuccess = false
    
    init() {}
    
    // Formateadores privados
    private var posgresDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    private var posgresTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }
    
    func crearEvento(matriculaOrganizador: Double) async {
        guard !nombreEvento.trimmingCharacters(in: .whitespaces).isEmpty,
              !lugar.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "El nombre y el lugar son obligatorios."
            return
        }
        
        guard let aforoNum = Double(aforoTexto) else {
            errorMessage = "El aforo debe detallarse numéricamente (ej. 100)."
            return
        }
        
        let stringFecha = posgresDateFormatter.string(from: fechaEvento)
        let stringHoraInicio = posgresTimeFormatter.string(from: horaInicio)
        let stringHoraFin = posgresTimeFormatter.string(from: horaFin)
        
        isLoading = true
        errorMessage = nil
        isSuccess = false
        
        // Simular latencia
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        let nuevoId = (MockDatabase.shared.eventos.map { $0.id }.max() ?? 0) + 1
        
        let nuevoEvento = Evento(
            id: nuevoId,
            fechaEvento: stringFecha,
            nombreEvento: nombreEvento.trimmingCharacters(in: .whitespaces),
            lugar: lugar.trimmingCharacters(in: .whitespaces),
            aforo: aforoNum,
            departamentoSolicitante: departamentoSolicitante,
            horaInicio: stringHoraInicio,
            horaFin: stringHoraFin,
            telefonoResponsable: telefonoResponsable,
            insumos: nil,
            organizadorId: matriculaOrganizador,
            categoria: categoria,
            imageUrl: nil,
            estado: "publicado",
            descripcion: descripcion
        )
        
        MockDatabase.shared.eventos.append(nuevoEvento)
        
        isSuccess = true
        resetForm()
        isLoading = false
    }
    
    func resetForm() {
        nombreEvento = ""
        fechaEvento = Date()
        horaInicio = Date()
        horaFin = Date().addingTimeInterval(3600)
        lugar = ""
        aforoTexto = ""
        descripcion = ""
        telefonoResponsable = ""
        departamentoSolicitante = ""
    }
}
