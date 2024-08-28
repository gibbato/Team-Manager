import SwiftUI

struct EditProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var primaryPosition: String = ""
    @State private var secondaryPosition: String = ""
    @State private var jerseyNumber: String = ""
    @State private var throwingHand: String = ""
    @State private var battingStance: String = ""

    let positions = ["Pitcher", "Catcher", "First Base", "Second Base", "Shortstop", "Third Base", "Left Field", "Left Center Field", "Right Center Field", "Right Field"]
    let hands = ["Right", "Left"]
    let stances = ["Right", "Left", "Switch"]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Name")) {
                    TextField("Name", text: $name)
                 
                }
                
                Section(header: Text("Player Details")) {
                    Picker("Primary Position", selection: $primaryPosition) {
                        ForEach(positions, id: \.self) {
                            Text($0)
                        }
                    }
                    
                    Picker("Secondary Position", selection: $secondaryPosition) {
                        ForEach(positions, id: \.self) {
                            Text($0)
                        }
                    }
                    
                    TextField("Jersey Number", text: $jerseyNumber)
                        .keyboardType(.numberPad)
                    
                    Picker("Throwing Hand", selection: $throwingHand) {
                        ForEach(hands, id: \.self) {
                            Text($0)
                        }
                    }
                    
                    Picker("Batting Stance", selection: $battingStance) {
                        ForEach(stances, id: \.self) {
                            Text($0)
                        }
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarItems(leading: Button("Cancel") {
                dismiss()
            }, trailing: Button("Save") {
                saveChanges()
                dismiss()
            })
            .onAppear {
                loadExistingData()
            }
        }
    }
    
    private func loadExistingData() {
        name = viewModel.getUserName()
        primaryPosition = viewModel.getPrimaryPosition()
        secondaryPosition = viewModel.getSecondaryPosition()
        jerseyNumber = String(viewModel.getJerseyNumber())
        throwingHand = viewModel.getThrowingHand()
        battingStance = viewModel.getBattingStance()
    }
    
    private func saveChanges() {
        print("Saving changes: name=\(name), email=\(email), primaryPosition=\(primaryPosition), secondaryPosition=\(secondaryPosition), jerseyNumber=\(jerseyNumber), throwingHand=\(throwingHand), battingStance=\(battingStance)")

        // Call ViewModel update methods only on Save button press
        viewModel.updateUserName(name)
        viewModel.updatePrimaryPosition(primaryPosition)
        viewModel.updateSecondaryPosition(secondaryPosition)
        if let jerseyNum = Int(jerseyNumber) {
            viewModel.updateJerseyNumber(jerseyNum)
        }
        viewModel.updateThrowingHand(throwingHand)
        viewModel.updateBattingStance(battingStance)
    }
}


#Preview {
    ProfileView()
        .environmentObject(AuthController())
}
