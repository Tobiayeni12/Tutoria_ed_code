import SwiftUI
import Foundation

struct ContentView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("savedUsername") private var savedUsername: String = ""
    @AppStorage("savedPassword") private var savedPassword: String = ""
    @AppStorage("studentDetails") private var studentDetailsData: Data = Data()
    
    var studentDetails: StudentDetails? {
        if let decoded = try? JSONDecoder().decode(StudentDetails.self, from: studentDetailsData) {
            return decoded
        }
        return nil
    }
    init() {
            // **FOR TESTING**: Always reset `isLoggedIn` when the app launches
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
        }


    var body: some View {
        Group {
            if isLoggedIn {
                MainAppView(studentDetails: studentDetails)
            } else {
                LoginView(isLoggedIn: $isLoggedIn, savedUsername: $savedUsername, savedPassword: $savedPassword)
            }
        }
    }
}


// MARK: - Login View








// Main App View



// Custom Tab Bar Button
struct TabBarButton: View {
    let systemName: String
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) { // Adjust spacing between icon and text
                Image(systemName: systemName)
                    .symbolVariant(isSelected ? .fill : .none)
                    .scaleEffect(isSelected ? 1.2 : 1.0) // Scale up when selected
                    .offset(y: isSelected ? -10 : 0) // Lift effect
                    .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isSelected)
                
                Text(label)
                    .font(.caption)
                    .foregroundColor(isSelected ? .green : .gray)
            }
            .frame(maxWidth: .infinity) // Ensure the button takes up all available space
        }
        .foregroundColor(isSelected ? .green : .gray)
    }
}

// Preview and other views remain the same
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


