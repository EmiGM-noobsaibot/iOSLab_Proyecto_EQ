import Foundation
#if canImport(Combine)
import Combine
#endif

@MainActor
final class AuthService: ObservableObject {
    /// Singleton para poder accederlo de forma global o inyectarlo en el Environment de SwiftUI
    static let shared = AuthService()
    
    // Eliminamos la dependencia del modelo User de Supabase para esta versión simplificada
    @Published var currentUser: String? = "1234567" // Matrícula falsa de prueba
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false // Empezamos en false
    
    private init() {
        // En la versión fácil, podemos iniciar deslogueados o logueados por defecto.
        // Lo dejaremos deslogueado para que se vea la pantalla de login.
    }
    
    /// Inicia sesión (Versión Mock)
    func signIn(email: String, password: String) async throws {
        // Simulamos un pequeño retraso de red
        try await Task.sleep(nanoseconds: 1_000_000_000)
        self.isAuthenticated = true
        self.currentUser = "1234567"
    }
    
    /// Cierra la sesión (Versión Mock)
    func signOut() async throws {
        self.isAuthenticated = false
        self.currentUser = nil
    }
}
