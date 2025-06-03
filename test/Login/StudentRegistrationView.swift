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
            Color.green
                .ignoresSafeArea() // Ensure the green background covers the entire screen
            Circle()
                .scale(1.7)
                .foregroundColor(.white.opacity(0.15))
            Circle()
                .scale(1.35)
                .foregroundColor(.white)
            
            VStack(spacing: 20) {
                Text("Student Registration")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                TextField("Full Name", text: $fullName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Picker("Level of Education", selection: $levelOfEducation) {
                    ForEach(educationLevels, id: \.self) { level in
                        Text(level)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                if levelOfEducation == "High School" {
                    TextField("High School Name", text: $highSchoolName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                } else {
                    TextField("University Name", text: $universityName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    TextField("Year of Study", text: $yearOfStudy)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    TextField("Major", text: $major)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
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
