import Foundation
#if canImport(Combine)
import Combine
#endif

@MainActor
class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var nombre = "" // Usado solo en pantalla de Registro
    
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    init() {}
    
    /// Valida que el estudiante haya llenado su matrícula/correo y pase
    private var isFormValid: Bool {
        return !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && 
               !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    /// Conecta con AuthService para hacer un signIn en vivo
    func login() async {
        guard isFormValid else {
            errorMessage = "Llena todos los campos vacíos."
            return
        }
        
        isLoading = true
        errorMessage = nil
        do {
            try await AuthService.shared.signIn(email: email, password: password)
        } catch {
            errorMessage = "Fallo al iniciar sesión."
        }
        isLoading = false
    }
    
    /// Registra un nuevo User (Simulado)
    func register() async {
        guard isFormValid, !nombre.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Asegúrate de llenar tu nombre completo también."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // Simular latencia de red
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Asumimos exito
        do {
            try await AuthService.shared.signIn(email: email, password: password)
        } catch {
            errorMessage = "Fallo al crear cuenta."
        }
        isLoading = false
    }
}
