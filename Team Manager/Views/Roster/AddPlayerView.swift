import SwiftUI

struct AddPlayerView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var role: String = ""
    @State private var isAvailable: Bool = true
    
    var onSave: (TeamMember?) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Player Information")) {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                    TextField("Role", text: $role)
                    Toggle("Available", isOn: $isAvailable)
                }
            }
            .navigationTitle("Add New Player")
            .navigationBarItems(leading: Button("Cancel") {
                dismiss()
            }, trailing: Button("Save") {
                savePlayer()
                dismiss()
            })
        }
    }
    
    private func savePlayer() {
        guard !name.isEmpty, !email.isEmpty, !role.isEmpty else {
            onSave(nil) // Pass nil to indicate that no player was saved
            return
        }
        
        let newPlayer = TeamMember(
            name: name,
            email: email,
            role: role,
            isAvailable: isAvailable
        )
        onSave(newPlayer)
    }
}
