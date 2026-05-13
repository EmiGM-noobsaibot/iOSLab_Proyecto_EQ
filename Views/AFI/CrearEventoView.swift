import SwiftUI

#if canImport(SwiftUI)
struct CrearEventoView: View {
    @StateObject private var viewModel = EventoViewModel()
    // Matricula temporal (idealmente inyectada del Auth global)
    let organizadorID: Double = 123456
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Card: Información Principal
                    VStack(alignment: .leading, spacing: 15) {
                        Label("Información Principal", systemImage: "info.circle.fill")
                            .font(.headline)
                            .foregroundColor(.miCuPrimary)

                        Divider()

                        TextField("Nombre del Evento", text: $viewModel.nombreEvento)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(10)

                        VStack(alignment: .leading, spacing: 5) {
                            Text("Categoría")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Picker("Categoría", selection: $viewModel.categoria) {
                                ForEach(CategoriaAFI.allCases, id: \.self) { cat in
                                    Text(cat.rawValue).tag(cat)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding(.horizontal, 10)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    
                    // Card: Horarios y Ubicación
                    VStack(alignment: .leading, spacing: 15) {
                        Label("Horarios y Ubicación", systemImage: "calendar.badge.clock")
                            .font(.headline)
                            .foregroundColor(.miCuPrimary)

                        Divider()

                        DatePicker("Fecha del evento", selection: $viewModel.fechaEvento, displayedComponents: .date)
                            .padding(.vertical, 5)

                        DatePicker("Hora de Inicio", selection: $viewModel.horaInicio, displayedComponents: .hourAndMinute)
                            .padding(.vertical, 5)

                        DatePicker("Hora de Fin", selection: $viewModel.horaFin, displayedComponents: .hourAndMinute)
                            .padding(.vertical, 5)

                        TextField("Lugar / Sede", text: $viewModel.lugar)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(10)
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    
                    // Card: Detalles Operativos
                    VStack(alignment: .leading, spacing: 15) {
                        Label("Detalles Operativos", systemImage: "person.3.fill")
                            .font(.headline)
                            .foregroundColor(.miCuPrimary)
                        
                        Divider()

                        TextField("Aforo (Capacidad Máxima ej: 100)", text: $viewModel.aforoTexto)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(10)

                        TextField("Teléfono Responsable", text: $viewModel.telefonoResponsable)
                            .keyboardType(.phonePad)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(10)

                        TextField("Departamento Solicitante", text: $viewModel.departamentoSolicitante)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(10)
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)

                    // Card: Descripción
                    VStack(alignment: .leading, spacing: 15) {
                        Label("Descripción de la Actividad", systemImage: "text.alignleft")
                            .font(.headline)
                            .foregroundColor(.miCuPrimary)

                        Divider()

                        TextEditor(text: $viewModel.descripcion)
                            .frame(minHeight: 120)
                            .padding(8)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)

                    // Botón de Publicar
                    Button(action: {
                        Task {
                            await viewModel.crearEvento(matriculaOrganizador: organizadorID)
                        }
                    }) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Image(systemName: "paperplane.fill")
                                Text("Publicar AFI")
                                    .fontWeight(.bold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.isLoading ? Color.gray : Color.miCuPrimary)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(color: Color.miCuPrimary.opacity(0.3), radius: 5, x: 0, y: 3)
                    }
                    .disabled(viewModel.isLoading)
                    .padding(.top, 10)
                    .padding(.bottom, 30)

                }
                .padding()
            }
            .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .navigationTitle("Crear Nuevo Evento")
            .alert(isPresented: Binding<Bool>(
                get: { viewModel.errorMessage != nil || viewModel.isSuccess },
                set: { _ in }
            )) {
                if viewModel.isSuccess {
                    return Alert(
                        title: Text("¡Éxito!"),
                        message: Text("El evento se publicó correctamente para los alumnos."),
                        dismissButton: .default(Text("Cerrar")) {
                            viewModel.isSuccess = false
                        }
                    )
                } else {
                    return Alert(
                        title: Text("Faltan datos"),
                        message: Text(viewModel.errorMessage ?? "Error desconocido"),
                        dismissButton: .default(Text("Entendido")) {
                            viewModel.errorMessage = nil
                        }
                    )
                }
            }
        }
    }
}

struct CrearEventoView_Previews: PreviewProvider {
    static var previews: some View {
        CrearEventoView()
    }
}
#endif
