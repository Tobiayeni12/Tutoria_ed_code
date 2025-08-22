import SwiftUI

struct StudentRegistrationView: View {
    @Binding var savedUsername: String
    @Binding var savedPassword: String
    @Binding var isShowingCreateAccount: Bool
    
    @State private var fullName: String = ""
    @State private var levelOfEducation: String = "High School"
    @State private var highSchoolName: String = ""
    @State private var universityName: String = ""
    @State private var yearOfStudy: String = ""
    @State private var major: String = ""
    @State private var showNextScreen: Bool = false
    
    let educationLevels = ["High School", "University"]
    
    var body: some View {
        ZStack {
            Color.green.ignoresSafeArea()
            Circle().scale(1.7).foregroundColor(.white.opacity(0.15))
            Circle().scale(1.35).foregroundColor(.white)
            
            VStack(spacing: 20) {
                Text("Student Registration")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // Custom-styled text fields
                StyledTextField(text: $fullName, placeholder: "Full Name")
                
                Picker("Level of Education", selection: $levelOfEducation) {
                    ForEach(educationLevels, id: \.self) { level in
                        Text(level)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                if levelOfEducation == "High School" {
                    StyledTextField(text: $highSchoolName, placeholder: "High School Name")
                } else {
                    StyledTextField(text: $universityName, placeholder: "University Name")
                    StyledTextField(text: $yearOfStudy, placeholder: "Year of Study")
                    StyledTextField(text: $major, placeholder: "Major")
                }
                
                Button(action: {
                    showNextScreen = true
                }) {
                    Text("Next")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationTitle("Student Registration")
        .navigationBarHidden(true)
        .background(
            NavigationLink(
                destination: CreateAccountView(
                    savedUsername: $savedUsername,
                    savedPassword: $savedPassword,
                    isShowingCreateAccount: $isShowingCreateAccount,
                    userType: "Student",
                    studentDetails: StudentDetails(
                        fullName: fullName,
                        levelOfEducation: levelOfEducation,
                        highSchoolName: highSchoolName,
                        universityName: universityName,
                        yearOfStudy: yearOfStudy,
                        major: major
                    )
                ),
                isActive: $showNextScreen
            ) { EmptyView() }
        )
    }
}

/// Reusable styled text field (same as LoginView)
private struct StyledTextField: View {
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color.black.opacity(0.35))
                    .padding(.horizontal, 16)
            }
            
            TextField("", text: $text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .foregroundColor(.black)
                .padding(12)
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(radius: 2, y: 1)
        )
        .padding(.horizontal)
    }
}
